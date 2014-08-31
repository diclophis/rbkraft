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

void Init_dynasty_io();

void Init_dynasty_io() {
  DynastyIO = rb_define_module("DynastyIO");
  rb_define_singleton_method(DynastyIO, "send_io2", method_dynasty_io_send_io, 2);
}

VALUE method_dynasty_io_send_io(VALUE self, VALUE sock, VALUE val) {
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

    /* Linux and Solaris doesn't work if msg_iov is NULL. */
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

}
