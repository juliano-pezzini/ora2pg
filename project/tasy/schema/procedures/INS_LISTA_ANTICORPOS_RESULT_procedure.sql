-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ins_lista_anticorpos_result (nr_seq_exame_p bigint, ds_lista_p text, nr_seq_peca_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_lista_w		varchar(255);
tam_lista_w		bigint;
ie_pos_virgula_w	bigint;
nr_seq_anticorpo_w	varchar(10);
ie_exite_w		bigint;


BEGIN


ds_lista_w := ds_lista_p;

while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '')  loop
	begin
	tam_lista_w		:= length(ds_lista_w);
	ie_pos_virgula_w		:= position(',' in ds_lista_w);

	if (ie_pos_virgula_w <> 0) then
		nr_seq_anticorpo_w	:= (substr(ds_lista_w,1,(ie_pos_virgula_w - 1)))::numeric;
		ds_lista_w		:= substr(ds_lista_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;

	select 	count(*)
	into STRICT	ie_exite_w
	from	prescr_proc_result_antic
	where	nr_seq_prescr_proc_compl = nr_seq_exame_p
	and	nr_seq_anticorpo = nr_seq_anticorpo_w
	and	nr_seq_prescr_proc_peca = nr_seq_peca_p;

	if (ie_exite_w = 0) then
		insert
		into	prescr_proc_result_antic(nr_sequencia,
			 dt_atualizacao,
			 nm_usuario,
			 dt_atualizacao_nrec,
			 nm_usuario_nrec,
			 nr_seq_anticorpo,
			 nr_seq_prescr_proc_compl,
			 ie_resultado,
			 ds_resultado,
			 nr_seq_prescr_proc_peca
			)
		values (nextval('prescr_proc_result_antic_seq'),
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 nr_seq_anticorpo_w,
			 nr_seq_exame_p,
			 null,
			 null,
			 nr_seq_peca_p
			);
	end if;
	end;
	end loop;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ins_lista_anticorpos_result (nr_seq_exame_p bigint, ds_lista_p text, nr_seq_peca_p bigint, nm_usuario_p text) FROM PUBLIC;

