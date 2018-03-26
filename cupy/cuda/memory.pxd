<<<<<<< HEAD
=======
from libcpp cimport bool
from libcpp cimport vector
>>>>>>> 347cb9a... Add memory log functions
from cupy.cuda cimport device

cdef class Chunk:

    cdef:
        readonly device.Device device
        readonly object mem
        readonly size_t ptr
        readonly Py_ssize_t offset
        readonly Py_ssize_t size
        public Chunk prev
        public Chunk next
        public bint in_use
        object __weakref__

cdef class MemoryPointer:

    cdef:
        readonly device.Device device
        readonly object mem
        readonly size_t ptr
        object __weakref__

    cpdef update_ptr(self, size_t ptr)
    cpdef copy_from_device(self, MemoryPointer src, Py_ssize_t size)
    cpdef copy_from_device_async(self, MemoryPointer src, size_t size, stream)
    cpdef copy_from_host(self, mem, size_t size)
    cpdef copy_from_host_async(self, mem, size_t size, stream)
    cpdef copy_from(self, mem, size_t size)
    cpdef copy_from_async(self, mem, size_t size, stream)
    cpdef copy_to_host(self, mem, size_t size)
    cpdef copy_to_host_async(self, mem, size_t size, stream)
    cpdef memset(self, int value, size_t size)
    cpdef memset_async(self, int value, size_t size, stream)


cpdef MemoryPointer alloc(Py_ssize_t size)


cpdef set_allocator(allocator=*)


cdef class SingleDeviceMemoryPool:

    cdef:
        bool profile_mode
        list memory_log
        list swapout_events
        object _allocator
        dict _in_use
        dict _in_use_memptr
        list _free
        object __weakref__
        object _weakref
        object _free_lock
        object _in_use_lock
        readonly Py_ssize_t _allocation_unit_size
        readonly Py_ssize_t _initial_bins_size
        readonly int _device_id
        vector.vector[int] _index

    cpdef set_profile_mode(self, bool flag)
    cpdef get_profile_mode(self)
    cpdef memory_log_reset(self)
    cpdef memory_log_add(self, tuple x)
    cpdef add_swapout_event(self, event)
    cpdef list memory_log_get(self)
    cpdef MemoryPointer _alloc(self, Py_ssize_t size)
    cpdef MemoryPointer malloc(self, Py_ssize_t size)
    cpdef MemoryPointer _malloc(self, Py_ssize_t size)
    cpdef free(self, size_t ptr, Py_ssize_t size)
    cpdef free_all_blocks(self)
    cpdef free_all_free(self)
    cpdef n_free_blocks(self)
    cpdef used_bytes(self)
    cpdef free_bytes(self)
    cpdef total_bytes(self)
    cpdef Py_ssize_t _round_size(self, Py_ssize_t size)
    cpdef int _bin_index_from_size(self, Py_ssize_t size)
    cpdef _append_to_free_list(self, Py_ssize_t size, chunk)
    cpdef bint _remove_from_free_list(self, Py_ssize_t size, chunk) except *
    cpdef tuple _split(self, Chunk chunk, Py_ssize_t size)
    cpdef Chunk _merge(self, Chunk head, Chunk remaining)
    cpdef classify_chunk_by_memptr(self)
    cpdef compact_chunks(self, list chunk_list)
    cpdef realloc(self, list chunk_list, Py_ssize_t size)
    cpdef realloc_all(self, dict chunk_list_dict, Py_ssize_t max_size)
    
    
cdef class MemoryPool:

    cdef:
        object _pools

    cpdef set_profile_mode(self, bool flag)
    cpdef get_profile_mode(self)
    cpdef memory_log_reset(self)
    cpdef memory_log_add(self, tuple x)
    cpdef add_swapout_event(self, event)
    cpdef list memory_log_get(self)
    cpdef MemoryPointer malloc(self, Py_ssize_t size)
    cpdef free_all_blocks(self)
    cpdef free_all_free(self)
    cpdef n_free_blocks(self)
    cpdef used_bytes(self)
    cpdef free_bytes(self)
    cpdef total_bytes(self)
