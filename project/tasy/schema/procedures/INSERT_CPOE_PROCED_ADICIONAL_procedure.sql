-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_cpoe_proced_adicional ( ds_procedimento_lista_p text, nr_seq_proc_cpoe_p bigint, nr_atendimento_p bigint, si_radiology_p text, nm_usuario_p text) AS $body$
DECLARE


ds_lista_w				varchar(4000);
tam_lista_w				bigint;
ie_pos_virgula_w		smallint;
nr_seq_proc_interno_w	cpoe_proced_adicional.nr_seq_proc_interno%type;
nr_sequencia_w			cpoe_proced_adicional.nr_sequencia%type;


BEGIN

ds_lista_w := ds_procedimento_lista_p;

while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '')  loop
	begin
	tam_lista_w			:= length(ds_lista_w);
	ie_pos_virgula_w	:= position(',' in ds_lista_w);

	if (ie_pos_virgula_w <> 0) then
		nr_seq_proc_interno_w	:= (substr(ds_lista_w, 1, (ie_pos_virgula_w - 1)))::numeric;
		ds_lista_w	:= substr(ds_lista_w, (ie_pos_virgula_w + 1), tam_lista_w);
	end if;
	
	if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then

		select	nextval('cpoe_proced_adicional_seq')
		into STRICT	nr_sequencia_w
		;
		
		insert into cpoe_proced_adicional(	
						nr_sequencia,
						nr_seq_proc_interno,
						nr_seq_proc_edit,
						nr_atendimento,
						dt_atualizacao,
						nm_usuario,
						si_radiology)
				values (nr_sequencia_w,
						nr_seq_proc_interno_w,
						nr_seq_proc_cpoe_p,
						nr_atendimento_p,
						clock_timestamp(),
						nm_usuario_p,
						coalesce(si_radiology_p, 'N'));
	end if;
	
	end;
	end loop;
commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_cpoe_proced_adicional ( ds_procedimento_lista_p text, nr_seq_proc_cpoe_p bigint, nr_atendimento_p bigint, si_radiology_p text, nm_usuario_p text) FROM PUBLIC;
