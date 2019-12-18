# Overview

This is a demo for Parallel Cluster. mpiprime.c will search for prime numbers between 1 and 100M. The job is configured to run across 4 nodes. While this is an embarrassing parallel job, mpi communications are used to reduce the results. The cluster is running the SGE scheduler, but cfncluster supports other schedulers as well.

The MPI code is an example from [here](https://computing.llnl.gov/tutorials/performance_tools/samples/mpi_prime.c). I could not find a license associated.

# Setup

Configure Parallel Cluster to scale with the following. This will cause the cluster to scale to exacly four nodes when a job is submitted. I use a t2.micro for demos.

* InitialQueueSize: 0
* MaxQueueSize: 4
* ScalingAdjustment: 4

Copy **mpiprime.c** and **mpiprime.sh** to **/shared** on the cluster and compile mpiprime.c. 


# Commands

**qstat** - lists the jobs in the job queue. When you first log in, there should be none.

**qhost** - show the hosts in the cluster. When you first log in, the head node is the only node the cluster. Compute nodes will be added as needed.

```
    HOSTNAME                ARCH         NCPU NSOC NCOR NTHR  LOAD  MEMTOT  MEMUSE  SWAPTO  SWAPUS
    ----------------------------------------------------------------------------------------------
    global                  -               -    -    -    -     -       -       -       -       -
```

**qsub /shared/mpiprime.sh** - submits the mpiprime job to the queue.

**qstat** - you should now see a single job in the "queued waiting (qw)" state. This job is waiting for compute nodes to launch to run the job.

``
    job-ID  prior   name       user         state submit/start at     queue                          slots ja-task-ID
    -----------------------------------------------------------------------------------------------------------------
         1  0.00000 mpiprime   ec2-user     qw    01/09/2018 20:37:33                                    4
```

**qhost** - after a few minutes you will see that four compute nodes have been added to the cluster.
    
```
    HOSTNAME                ARCH         NCPU NSOC NCOR NTHR  LOAD  MEMTOT  MEMUSE  SWAPTO  SWAPUS
    ----------------------------------------------------------------------------------------------
    global                  -               -    -    -    -     -       -       -       -       -
    ip-172-16-33-111        lx-amd64        1    1    1    1  0.04  993.4M  208.5M     0.0     0.0
    ip-172-16-36-200        lx-amd64        1    1    1    1  0.06  993.4M  173.0M     0.0     0.0
    ip-172-16-37-157        lx-amd64        1    1    1    1  0.04  993.4M  173.3M     0.0     0.0
    ip-172-16-41-57         lx-amd64        1    1    1    1  0.04  993.4M  208.0M     0.0     0.0
```

**cat /shared/mpiprime.txt** - after about 30 seconds, the job will finish and you can see the output.

```
    Using 4 tasks to scan 100000000 numbers
    Done. Largest prime is 99999989 Total primes 5761455
    Wallclock time elapsed: 22.44 seconds
```