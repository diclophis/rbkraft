#include <ruby.h>
#include <ruby/io.h>

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/socket.h>

//TODO: fix these hacks!!!

VALUE rb_thread_io_blocking_region(rb_blocking_function_t *func, void *data1, int fd);

struct iomsg_arg {
  int fd;
  struct msghdr msg;
};

static VALUE
sendmsg_blocking(void *data)
{
    struct iomsg_arg *arg = data;
    return sendmsg(arg->fd, &arg->msg, 0);
}

#define FD_PASSING_BY_MSG_CONTROL 1
#define FD_PASSING_BY_MSG_ACCRIGHTS 0
#define BLOCKING_REGION_FD(func, arg) (long)rb_thread_io_blocking_region((func), (arg), (arg)->fd)
//TODO: fix these hacks!!!

VALUE DynastyIO = Qnil;

VALUE method_dynasty_io_send_io(VALUE self, VALUE sock, VALUE val);
VALUE method_dynasty_io_recv_io(VALUE self, VALUE sock);

void Init_dynasty_io();

void Init_dynasty_io() {
  DynastyIO = rb_define_module("DynastyIO");
  rb_define_singleton_method(DynastyIO, "send_io2", method_dynasty_io_send_io, 2);
  rb_define_singleton_method(DynastyIO, "recv_io2", method_dynasty_io_recv_io, 1);
}

VALUE method_dynasty_io_send_io(VALUE self, VALUE isock, VALUE val) {
/*
    int fd;
    rb_io_t *fptr;
    struct iomsg_arg arg;
    struct iovec vec[1];
    char buf[1];

#if FD_PASSING_BY_MSG_CONTROL
    struct {
        struct cmsghdr hdr;
        char pad[8+sizeof(int)+8];
    } cmsg;
#endif

    if (rb_obj_is_kind_of(val, rb_cIO)) {
        rb_io_t *valfptr;
        GetOpenFile(val, valfptr);
        fd = valfptr->fd;
    }
    else if (FIXNUM_P(val)) {
        fd = FIX2INT(val);
    }
    else {
        rb_raise(rb_eTypeError, "neither IO nor file descriptor");
    }

    GetOpenFile(sock, fptr);

    arg.msg.msg_name = NULL;
    arg.msg.msg_namelen = 0;

    // Linux and Solaris doesn't work if msg_iov is NULL.
    buf[0] = '\0';
    vec[0].iov_base = buf;
    vec[0].iov_len = 1;
    arg.msg.msg_iov = vec;
    arg.msg.msg_iovlen = 1;

#if FD_PASSING_BY_MSG_CONTROL
    arg.msg.msg_control = (caddr_t)&cmsg;
    arg.msg.msg_controllen = (socklen_t)CMSG_LEN(sizeof(int));
    arg.msg.msg_flags = 0;
    MEMZERO((char*)&cmsg, char, sizeof(cmsg));
    cmsg.hdr.cmsg_len = (socklen_t)CMSG_LEN(sizeof(int));
    cmsg.hdr.cmsg_level = SOL_SOCKET;
    cmsg.hdr.cmsg_type = SCM_RIGHTS;
    memcpy(CMSG_DATA(&cmsg.hdr), &fd, sizeof(int));
#else
    arg.msg.msg_accrights = (caddr_t)&fd;
    arg.msg.msg_accrightslen = sizeof(fd);
#endif

    arg.fd = fptr->fd;
    while ((int)BLOCKING_REGION_FD(sendmsg_blocking, &arg) == -1) {
        if (!rb_io_wait_writable(arg.fd))
            rb_sys_fail("sendmsg(2)");
    }

    return Qnil;

*/
    
  int fd;
  int sock;

  rb_io_t *fptr;
  GetOpenFile(isock, fptr);
  sock = fptr->fd;

  if (rb_obj_is_kind_of(val, rb_cIO)) {
      rb_io_t *valfptr;
      GetOpenFile(val, valfptr);
      fd = valfptr->fd;
  }
  else if (FIXNUM_P(val)) {
      fd = FIX2INT(val);
  }
  else {
      rb_raise(rb_eTypeError, "neither IO nor file descriptor");
  }

  struct msghdr hdr;
  struct iovec data;

  char cmsgbuf[CMSG_SPACE(sizeof(int))];

  char dummy = '*';
  data.iov_base = &dummy;
  data.iov_len = sizeof(dummy);

  memset(&hdr, 0, sizeof(hdr));
  hdr.msg_name = NULL;
  hdr.msg_namelen = 0;
  hdr.msg_iov = &data;
  hdr.msg_iovlen = 1;
  hdr.msg_flags = 0;

  hdr.msg_control = cmsgbuf;
  hdr.msg_controllen = CMSG_LEN(sizeof(int));

  struct cmsghdr* cmsg = CMSG_FIRSTHDR(&hdr);
  cmsg->cmsg_len   = CMSG_LEN(sizeof(int));
  cmsg->cmsg_level = SOL_SOCKET;
  cmsg->cmsg_type  = SCM_RIGHTS;

  *(int*)CMSG_DATA(cmsg) = fd;

  int n = sendmsg(sock, &hdr, 0);

  if(n == -1) {
    printf("sendmsg() failed: %s (socket fd = %d)\n", strerror(errno), sock);
  }

  return n;


}


VALUE method_dynasty_io_recv_io(VALUE self, VALUE isock) {
  rb_io_t *fptr;
  GetOpenFile(isock, fptr);
  int s = fptr->fd;

  int n;
  int fd;
  char buf[1];
  struct iovec iov;
  struct msghdr msg;
  struct cmsghdr *cmsg;
  char cms[CMSG_SPACE(sizeof(int))];

  iov.iov_base = buf;
  iov.iov_len = 1;

  memset(&msg, 0, sizeof msg);
  msg.msg_name = 0;
  msg.msg_namelen = 0;
  msg.msg_iov = &iov;
  msg.msg_iovlen = 1;

  msg.msg_control = (caddr_t)cms;
  msg.msg_controllen = sizeof cms;

  if((n=recvmsg(s, &msg, 0)) < 0) {
    return -1;
  }

  if(n == 0){
    printf("unexpected EOF\n");
    return -1;
  }

  cmsg = CMSG_FIRSTHDR(&msg);
  memmove(&fd, CMSG_DATA(cmsg), sizeof(int));

  return INT2FIX(fd);
}
