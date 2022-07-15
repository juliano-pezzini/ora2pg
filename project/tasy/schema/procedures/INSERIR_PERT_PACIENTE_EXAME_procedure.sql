-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_pert_paciente_exame ( nm_usuario_p text, ds_lista_p text, nr_atendimento_p bigint, ie_ponto_controle_p text) AS $body$
DECLARE


ds_lista_w		varchar(1000);
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
nr_seq_pert_exame_w	bigint;
ds_pert_exame_w		varchar(80);
nr_seq_exame_paciente_w	bigint;

BEGIN

ds_lista_w := ds_lista_p;

while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '')  loop
	begin
	tam_lista_w		:= length(ds_lista_w);
	ie_pos_virgula_w	:= position(',' in ds_lista_w);

	if (ie_pos_virgula_w <> 0) then
		nr_seq_pert_exame_w := (substr(ds_lista_w,1,(ie_pos_virgula_w - 1)))::numeric;
		ds_lista_w	:= substr(ds_lista_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;

	select	ds_pertence
	into STRICT	ds_pert_exame_w
	from	pertence_item
	where	nr_sequencia = nr_seq_pert_exame_w;

	select	nextval('exame_paciente_seq')
	into STRICT	nr_seq_exame_paciente_w
	;

	insert into exame_paciente(
	                            nr_sequencia,
				    ie_ponto_controle,
				    nr_atendimento,
				    dt_atualizacao,
				    nm_usuario,
				    nm_usuario_rec,
				    dt_recebimento,
				    ds_exame,
				    ie_situacao
				    )
			values (
			            nr_seq_exame_paciente_w,
				    ie_ponto_controle_p,
				    nr_atendimento_p,
				    clock_timestamp(),
				    nm_usuario_p,
				    nm_usuario_p,
				    clock_timestamp(),
				    substr(ds_pert_exame_w,1,80),
				    'A');

	end;
	end loop;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_pert_paciente_exame ( nm_usuario_p text, ds_lista_p text, nr_atendimento_p bigint, ie_ponto_controle_p text) FROM PUBLIC;

