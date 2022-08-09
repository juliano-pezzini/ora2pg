-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_enviados_js ( nr_lote_producao_p bigint, nr_seq_componente_p bigint, ds_lista_p text, nm_usuario_p text) AS $body$
DECLARE


nr_pos_virgula_w	bigint;
nr_seq_documento_w	bigint;
ds_lista_w		varchar(2000);

BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (ds_lista_p IS NOT NULL AND ds_lista_p::text <> '') then
	begin
	ds_lista_w	:= ds_lista_p;

	while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') loop
		begin
		nr_pos_virgula_w	:= position(',' in ds_lista_w);

		if (nr_pos_virgula_w > 0) then
			begin
			nr_seq_documento_w	:= (substr(ds_lista_w,0,nr_pos_virgula_w -1))::numeric;
			ds_lista_w		:= substr(ds_lista_w,nr_pos_virgula_w +1, length(ds_lista_w));
			end;
		else
			begin
			nr_seq_documento_w	:= (ds_lista_w)::numeric;
			ds_lista_w		:= null;
			end;
		end if;

		if (nr_seq_documento_w IS NOT NULL AND nr_seq_documento_w::text <> '') then
			begin
			CALL itens_enviados_proto_opme(nr_lote_producao_p,nr_seq_componente_p,nr_seq_documento_w,nm_usuario_p);
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
-- REVOKE ALL ON PROCEDURE gerar_itens_enviados_js ( nr_lote_producao_p bigint, nr_seq_componente_p bigint, ds_lista_p text, nm_usuario_p text) FROM PUBLIC;
