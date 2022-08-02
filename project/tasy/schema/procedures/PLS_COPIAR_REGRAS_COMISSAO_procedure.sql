-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_regras_comissao ( nr_seq_vendedor_p bigint, ds_sequencia_p text, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


ds_sequencia_w			varchar(1000);	/* Conjunto de identificadores de repasses */
ie_pos_virgula_w			smallint;	/* posicao da virgula */
tam_lista_w			bigint;	/* tamanha da lista de ds_sequencia_w */
nr_sequencia_w			bigint;	/* identificador atual */
nr_controle_loop_w			smallint := 0;	/* controle do loop */
BEGIN
if (ds_sequencia_p IS NOT NULL AND ds_sequencia_p::text <> '') then
	begin
	ds_sequencia_w 	:= ds_sequencia_p;

	while(ds_sequencia_w IS NOT NULL AND ds_sequencia_w::text <> '') and (nr_controle_loop_w < 100) loop
		begin
		tam_lista_w		:= length(ds_sequencia_w);
		ie_pos_virgula_w	:= position(',' in ds_sequencia_w);
		nr_sequencia_w	:= 0;

		if (ie_pos_virgula_w <> 0) then
			begin
			nr_sequencia_w	:= (substr(ds_sequencia_w,1,(ie_pos_virgula_w - 1)))::numeric;
			ds_sequencia_w	:= substr(ds_sequencia_w,(ie_pos_virgula_w + 1),tam_lista_w);
			end;
		else
			begin
			nr_sequencia_w	:= (ds_sequencia_w)::numeric;
			ds_sequencia_w	:= null;
			end;
		end if;

		if (coalesce(nr_sequencia_w,0) > 0) then
			begin
			CALL pls_copiar_regra_comissao(nr_seq_vendedor_p, nr_sequencia_w, ie_opcao_p, nm_usuario_p);
			end;
		end if;

		nr_controle_loop_w := nr_controle_loop_w + 1;
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
-- REVOKE ALL ON PROCEDURE pls_copiar_regras_comissao ( nr_seq_vendedor_p bigint, ds_sequencia_p text, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

