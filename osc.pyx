from libc.stdint cimport int32_t, int64_t
cdef extern from 'lo/lo.h':
    ctypedef void* lo_address
    ctypedef void* lo_message
    lo_address lo_address_new(char *host, char *port)
    void lo_address_free(lo_address t)
    int lo_send_message(lo_address targ, char *path, lo_message msg)
    lo_message lo_message_new()
    void lo_message_free(lo_message m)
    int lo_message_add_int32(lo_message m, int32_t a)
    int lo_message_add_float(lo_message m, float a)
    int lo_message_add_string(lo_message m, char *a)
    #int lo_message_add_blob(lo_message m, lo_blob a)
    int lo_message_add_int64(lo_message m, int64_t a)
    #int lo_message_add_timetag(lo_message m, lo_timetag a)
    int lo_message_add_double(lo_message m, double a)
    int lo_message_add_symbol(lo_message m, char *a)
    int lo_message_add_char(lo_message m, char a)
    #int lo_message_add_midi(lo_message m, uint8_t a[4])
    int lo_message_add_true(lo_message m)
    int lo_message_add_false(lo_message m)
    int lo_message_add_nil(lo_message m)
    int lo_message_add_infinitum(lo_message m)

cdef class OSC:
    cdef lo_address addr

    def __del__(self):
        self.disconnect()
    def connect(self, serv, port):
        self.disconnect()
        serv = serv.encode('ascii')
        port = str(port).encode('ascii')
        self.addr = lo_address_new(serv, port)
        #raise IOError(2, 'Problem connecting to host', '%s:%s')
    def disconnect(self):
        lo_address_free(self.addr)
    def send(self, path, params):
        msg = lo_message_new()
        path = path.encode('ascii')
        #if type(params) in 
        try:
            if not hasattr(params, '__iter__'):
                self.add_message(msg, params)
            else:
                for p in params:
                    self.add_message(msg, p)
            ret = lo_send_message(self.addr, path, msg)
            if ret == -1:
                raise IOError(2, 'Unable to send message', path)
        finally:
            lo_message_free(msg)

    cdef add_message(self, lo_message msg, p):
        if type(p) == int:
            lo_message_add_int32(msg, p)
        elif type(p) == float:
            lo_message_add_float(msg, p)
        elif type(p) == str:
            p = p.encode('ascii')
            lo_message_add_string(msg, p)
        elif type(p) == bool:
            if p:
                lo_message_add_true(msg)
            else:
                lo_message_add_false(msg)
        elif p == None:
            lo_message_add_nil(msg)
        else:
            raise TypeError('Unsupported type \'%s\' for OSC.send()'%repr(type(p)))

