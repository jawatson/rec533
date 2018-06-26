      subroutine del_abt     !  delete the recarea.abt & rec533.abt files
c**********************************************************
      common /crun_directory/ run_directory
         character run_directory*50
      nch_run=lcount(run_directory,50)
c          make sure the ABORT file is not there
      call erase@(run_directory(1:nch_run)//'\recarea.abt',error_code)
      call erase@(run_directory(1:nch_run)//'\rec533.abt',error_code)
      return
      END
* -------------------------------------------------------------------- *
