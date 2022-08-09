-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_regra_agendas_cirurgicas ( cd_estabelecimento_p bigint, nm_usuario_p text, ds_lista_regras_p text, ds_lista_agendas_p text) AS $body$
DECLARE

ds_lista_regras_w	varchar(4000);
nr_seq_regra_w		bigint;
qt_tam_lista_w		bigint;
ie_pos_virgula_w 	integer;

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (ds_lista_regras_p IS NOT NULL AND ds_lista_regras_p::text <> '') and (ds_lista_agendas_p IS NOT NULL AND ds_lista_agendas_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	begin
	ds_lista_regras_w := ds_lista_regras_p;

	while(ds_lista_regras_w IS NOT NULL AND ds_lista_regras_w::text <> '') loop
		begin
		qt_tam_lista_w		:= length(ds_lista_regras_w);
		ie_pos_virgula_w	:= position(',' in ds_lista_regras_w);

		if (ie_pos_virgula_w <> 0) then
			begin
			nr_seq_regra_w		:= substr(ds_lista_regras_w,1,(ie_pos_virgula_w - 1));
			ds_lista_regras_w	:= substr(ds_lista_regras_w,(ie_pos_virgula_w + 1),qt_tam_lista_w);
			end;
		else
			begin
			nr_seq_regra_w	:= (ds_lista_regras_w)::numeric;
			ds_lista_regras_w	:= null;
			end;
		end if;

		if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') and (nr_seq_regra_w > 0) then
			begin
			CALL gerar_regra_agenda_cirurgica(
					nr_seq_regra_w,
					ds_lista_agendas_p,
					nm_usuario_p,
					cd_estabelecimento_p);
			end;
		end if;
		end;
	end loop;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_regra_agendas_cirurgicas ( cd_estabelecimento_p bigint, nm_usuario_p text, ds_lista_regras_p text, ds_lista_agendas_p text) FROM PUBLIC;
