-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_planos ( nr_seq_plano_origem_p bigint, nr_seq_plano_destino_p bigint, ie_excluir_p text, ds_lista_opcoes_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_lista_opcoes_w	varchar(2000);
nr_pos_virgula_w	bigint;
ds_opcao_w		bigint;
ds_erro_w		varchar(255);


BEGIN
if (nr_seq_plano_origem_p IS NOT NULL AND nr_seq_plano_origem_p::text <> '') and (nr_seq_plano_destino_p IS NOT NULL AND nr_seq_plano_destino_p::text <> '') and (ds_lista_opcoes_p IS NOT NULL AND ds_lista_opcoes_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ds_lista_opcoes_w := ds_lista_opcoes_p;

	while(ds_lista_opcoes_w IS NOT NULL AND ds_lista_opcoes_w::text <> '') loop
		begin
		nr_pos_virgula_w	:= position(',' in ds_lista_opcoes_w);
		if (nr_pos_virgula_w > 0) then
			begin
			ds_opcao_w		:= substr(ds_lista_opcoes_w,0,nr_pos_virgula_w-1);
			ds_lista_opcoes_w	:= substr(ds_lista_opcoes_w,nr_pos_virgula_w+1,length(ds_lista_opcoes_w));
			end;
		else
			begin
			ds_opcao_w		:= ds_lista_opcoes_w;
			ds_lista_opcoes_w	:= null;
			end;
		end if;

		ds_erro_w := pls_copiar_plano(
			nr_seq_plano_origem_p, nr_seq_plano_destino_p, ie_excluir_p, ds_opcao_w, nm_usuario_p, ds_erro_w);
		end;
	end loop;
	end;
end if;
ds_erro_p	:= ds_erro_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_planos ( nr_seq_plano_origem_p bigint, nr_seq_plano_destino_p bigint, ie_excluir_p text, ds_lista_opcoes_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

