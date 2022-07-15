-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_proced_pac_intilab_ws ( nr_prontuario_p bigint, cd_exame_p text, dt_procedimento_p text, ds_erro_p INOUT text) AS $body$
DECLARE

					
  cd_pessoa_fisica_w  		pessoa_fisica.cd_pessoa_fisica%type;
  nr_atendimento_w    		atendimento_paciente.nr_atendimento%type;
  nr_seq_proc_interno_w		procedimento_paciente.nr_seq_proc_interno%type;

  dt_procedimento_w  timestamp;
  dt_procedimento_varchar_w   varchar(40);
  ds_erro_w          varchar(2000);


BEGIN

  begin
        select substr(dt_procedimento_p,9,2)||'/'||
               substr(dt_procedimento_p,6,2)||'/'||                
               substr(dt_procedimento_p,1,4)||' '||
               substr(dt_procedimento_p,12,2)||':'||
               substr(dt_procedimento_p,15,2) ||':'||
               substr(dt_procedimento_p,18,2)
               into STRICT dt_procedimento_varchar_w
;
        exception
        when others then
             dt_procedimento_w := clock_timestamp();
        end;
  
  dt_procedimento_w := coalesce(to_date(dt_procedimento_varchar_w,'dd/MM/yyyy HH24:mi:ss'), dt_procedimento_w);

  begin
	select	cd_pessoa_fisica 
	into STRICT	cd_pessoa_fisica_w
 	from	pessoa_fisica
	where  	nr_prontuario = nr_prontuario_p;

	exception
      	when others then        
      	ds_erro_w  := obter_desc_expressao(513083,'');
      	goto final_ds_erro;
	
  end;

  begin
      	select	nr_seq_proc_interno				
	into STRICT	nr_seq_proc_interno_w	
	from	exame_laboratorio
	where	cd_exame = cd_exame_p;

      	exception
      	when others then        
      	ds_erro_w  := obter_desc_expressao(621266,'');
      	goto final_ds_erro;
	
  end;

    	select	coalesce(max(a.nr_atendimento),0) nr_atendimento
    	into STRICT    	nr_atendimento_w
    	from    	pessoa_fisica b,
		atendimento_paciente_v a
	where   	a.cd_pessoa_fisica = b.cd_pessoa_fisica
	and     	b.nr_prontuario = nr_prontuario_p;

	begin
		delete from procedimento_paciente
		where nr_atendimento = nr_atendimento_w
		and nr_seq_proc_interno = nr_seq_proc_interno_w
		and dt_procedimento = dt_procedimento_w;
	exception
          	when others then
          	ds_erro_w := sqlerrm;
          	goto final_ds_erro;
        end;
	
<<final_ds_erro>>
ds_erro_p  := substr(ds_erro_w,1,255);
commit;					

					
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_proced_pac_intilab_ws ( nr_prontuario_p bigint, cd_exame_p text, dt_procedimento_p text, ds_erro_p INOUT text) FROM PUBLIC;

