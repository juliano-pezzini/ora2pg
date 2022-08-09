-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_patient_checklist ( nm_usuario_p text, nr_seq_checklist_p bigint, ds_valor_result_p text, nr_seq_item_checklist_p bigint, ie_edit_checklist_p text, ds_arquivo_p text) AS $body$
DECLARE


ie_componente_w			varchar(10);
ds_valor_result_w		atend_pac_checklist_result.ds_valor_result%type;
nr_seq_valor_result_w	atend_pac_checklist_result.nr_seq_valor_result%type;


BEGIN

if (nr_seq_checklist_p IS NOT NULL AND nr_seq_checklist_p::text <> '') and (nr_seq_item_checklist_p IS NOT NULL AND nr_seq_item_checklist_p::text <> '') then
	begin

	select	max(ie_formato)
	into STRICT	ie_componente_w
	from	convenio_checklist_item
	where	nr_sequencia = nr_seq_item_checklist_p;

	if (ie_componente_w in ('ED','ME')) then
		begin
		ds_valor_result_w := ds_valor_result_p;
		end;
	else
		begin
		nr_seq_valor_result_w := (ds_valor_result_p)::numeric;
		end;
	end if;

	if (ie_edit_checklist_p = 'S') then

		update	atend_pac_checklist_result
		set		nr_seq_valor_result 	= nr_seq_valor_result_w,
				ds_valor_result 		= ds_valor_result_w,
				ds_arquivo				= ds_arquivo_p,
				dt_atualizacao_nrec 	= clock_timestamp(),
				nm_usuario_nrec			= nm_usuario_p
		where	nr_seq_checklist 		= nr_seq_checklist_p
		and		nr_seq_item_checklist 	= nr_seq_item_checklist_p;

	else

		insert into atend_pac_checklist_result(
					nr_sequencia,
					nm_usuario_result,
					nm_usuario,
					nm_usuario_nrec,
					dt_resultado,
					dt_atualizacao,
					dt_atualizacao_nrec,
					ds_arquivo,
					nr_seq_checklist,
					nr_seq_item_checklist,
					nr_seq_valor_result,
					ds_valor_result)
				values (
					nextval('atend_pac_checklist_result_seq'),
					nm_usuario_p,
					nm_usuario_p,
					nm_usuario_p,
					clock_timestamp(),
					clock_timestamp(),
					clock_timestamp(),
					ds_arquivo_p,
					nr_seq_checklist_p,
					nr_seq_item_checklist_p,
					nr_seq_valor_result_w,
					ds_valor_result_w);
	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_patient_checklist ( nm_usuario_p text, nr_seq_checklist_p bigint, ds_valor_result_p text, nr_seq_item_checklist_p bigint, ie_edit_checklist_p text, ds_arquivo_p text) FROM PUBLIC;
