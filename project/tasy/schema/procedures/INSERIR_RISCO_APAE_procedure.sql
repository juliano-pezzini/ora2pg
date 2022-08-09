-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_risco_apae (nr_seq_apae_p bigint, ds_lista_riscos_p text, nm_usuario_p text) AS $body$
DECLARE


ds_lista_riscos_w	varchar(1000);
tam_lista_w			bigint;
ie_pos_virgula_w	bigint;
qt_passou_w			smallint := 0;
nr_seq_risco_w		bigint;
nr_seq_risco_item_w	bigint;


BEGIN

ds_lista_riscos_w := ds_lista_riscos_p;

while	(ds_lista_riscos_w IS NOT NULL AND ds_lista_riscos_w::text <> '') loop
	begin
	tam_lista_w		:= length(ds_lista_riscos_w);

	ie_pos_virgula_w	:= position(',' in ds_lista_riscos_w);
	qt_passou_w := qt_passou_w + 1;

	if (ie_pos_virgula_w <> 0) then
		if (qt_passou_w = 1) then
			nr_seq_risco_w	:= (substr(ds_lista_riscos_w,1,(ie_pos_virgula_w - 1)))::numeric;
		else
			qt_passou_w	:= 0;
			nr_seq_risco_item_w := (substr(ds_lista_riscos_w,1,(ie_pos_virgula_w - 1)))::numeric;

			insert into resultado_risco_apae(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_apae,
				nr_seq_risco,
				nr_seq_risco_item)
			values (
				nextval('resultado_risco_apae_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_apae_p,
				nr_seq_risco_w,
				nr_seq_risco_item_w);

		end if;
		ds_lista_riscos_w	:= substr(ds_lista_riscos_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_risco_apae (nr_seq_apae_p bigint, ds_lista_riscos_p text, nm_usuario_p text) FROM PUBLIC;
