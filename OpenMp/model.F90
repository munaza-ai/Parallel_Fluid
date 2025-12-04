program atmosphere_model
  use calculation_types, only : wp
  use module_physics, only : dt, oldstat, newstat, flux, tend, ref
  use module_physics, only : init, finalize
  use module_physics, only : rungekutta, total_mass_energy
  use module_output, only : create_output, write_record, close_output
  use dimensions , only : sim_time, output_freq, read_params 
  use iodir, only : stdout
  use module_types, only : t3, t4, t5, t6, t7, rate
  use module_physics, only : t8, t9
#ifdef _OPENMP
  use omp_lib
#endif
  implicit none

  real(wp) :: etime
  real(wp) :: ptime
  real(wp) :: output_counter
  real(wp) :: pctime
  real(wp) :: mass0, te0
  real(wp) :: mass1, te1
  integer(8) :: t1, t2
  integer :: nthreads

  !================================= read the namelist parameters
   call read_params()
 !  write(stdout,*) "nx=", nx, " nz=", nz, " sim_time=", sim_time, " output_freq=", output_freq! to print on the console which params we are using
  write(stdout, *) 'SIMPLE ATMOSPHERIC MODEL STARTING.'
  call init(etime,output_counter,dt)
  call total_mass_energy(mass0,te0)
  call create_output( )
  call write_record(oldstat,ref,etime)

  call system_clock(t1)

  ptime = int(sim_time/10.0)
  do while (etime < sim_time)

    if (etime + dt > sim_time) dt = sim_time - etime

    call rungekutta(oldstat,newstat,flux,tend,dt)

    if ( mod(etime,ptime) < dt ) then
      pctime = (etime/sim_time)*100.0_wp
      write(stdout,'(1x,a,i2,a)') 'TIME PERCENT : ', int(pctime), '%'
    end if

    etime = etime + dt
    output_counter = output_counter + dt

    if (output_counter >= output_freq) then
      output_counter = output_counter - output_freq
      call write_record(oldstat,ref,etime)
    end if
  end do

  call total_mass_energy(mass1,te1)
  call close_output( )

  write(stdout,*) "----------------- Atmosphere check ----------------"
  write(stdout,*) "Fractional Delta Mass  : ", (mass1-mass0)/mass0
  write(stdout,*) "Fractional Delta Energy: ", (te1-te0)/te0
  write(stdout,*) "---------------------------------------------------"

  call finalize()
  call system_clock(t2,rate)

  write(stdout,*) "SIMPLE ATMOSPHERIC MODEL RUN COMPLETED."
  write(stdout,*) "USED CPU TIME: ", dble(t2-t1)/dble(rate)
  
  write(stdout,*) "USED CPU TIME no rate: ", (t2-t1)

#ifdef _OPENMP
  !$omp parallel
  if (omp_get_thread_num() == 0) then
    write(stdout,*) "OpenMP threads: ", omp_get_num_threads()
  end if
  !$omp end parallel
#endif

  write(stdout,*) "xtend for variables"
  write(stdout,*) "TIME: ", t3

  write(stdout,*) "ztend for flux"
  write(stdout,*) "TIME: ", t4

  write(stdout,*) "ztend for variables"
  write(stdout,*) "TIME: ", t5

  write(stdout,*) "xtend for flux"
  write(stdout,*) "TIME: ", t6

  write(stdout,*) "update loop"
  write(stdout,*) "TIME: ", t7

end program atmosphere_model
