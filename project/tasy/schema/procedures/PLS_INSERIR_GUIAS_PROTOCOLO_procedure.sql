-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_guias_protocolo ( ds_lista_guia_p text, nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_lista_guia_w		varchar(2000);
nr_pos_virgula_w	bigint;
nr_seq_guia_w		bigint;


BEGIN

if (ds_lista_guia_p IS NOT NULL AND ds_lista_guia_p::text <> '') and (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	ds_lista_guia_w		:= ds_lista_guia_p;

	while(ds_lista_guia_w IS NOT NULL AND ds_lista_guia_w::text <> '') loop
		begin
		nr_pos_virgula_w	:= position(',' in ds_lista_guia_w);

		if (nr_pos_virgula_w > 0) then
			begin
			nr_seq_guia_w		:= (substr(ds_lista_guia_w,0,nr_pos_virgula_w-1))::numeric;
			ds_lista_guia_w		:= substr(ds_lista_guia_w,nr_pos_virgula_w+1,length(ds_lista_guia_w));
			end;
		else
			begin
			nr_seq_guia_w		:= (ds_lista_guia_w)::numeric;
			ds_lista_guia_w		:= null;
			end;
		end if;

		if (nr_seq_guia_w > 0) then
			begin
			CALL pls_inserir_guia_protocolo(
				nr_seq_guia_w,
				nr_seq_protocolo_p,
				cd_estabelecimento_p,
				nm_usuario_p
				);
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
-- REVOKE ALL ON PROCEDURE pls_inserir_guias_protocolo ( ds_lista_guia_p text, nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
