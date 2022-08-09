-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_inserir_cli_rot (nr_seq_cliente_p bigint, ds_lista_roteiro_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
ds_lista_roteiro_w		varchar(800);
tam_lista_w			bigint;
ie_pos_virgula_w		smallint := 0;
nr_seq_roteiro_w		bigint;


BEGIN

ds_lista_roteiro_w	:= ds_lista_roteiro_p;
if (ds_lista_roteiro_w IS NOT NULL AND ds_lista_roteiro_w::text <> '') then
	begin
	WHILE(ds_lista_roteiro_w IS NOT NULL AND ds_lista_roteiro_w::text <> '') LOOP
		begin

		tam_lista_w			:= length(ds_lista_roteiro_w);
		ie_pos_virgula_w		:= position(',' in ds_lista_roteiro_w);

		if (ie_pos_virgula_w <> 0) then
			nr_seq_roteiro_w	:= substr(ds_lista_roteiro_w,1,(ie_pos_virgula_w - 1));
			ds_lista_roteiro_w	:= substr(ds_lista_roteiro_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end if;

		select	nextval('proj_tp_cli_rot_seq')
		into STRICT	nr_sequencia_w
		;

		insert	into proj_tp_cli_rot(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_roteiro,
			nr_seq_cliente)
		values ( nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_roteiro_w,
			nr_seq_cliente_p);

		CALL proj_gerar_rot_item(nr_sequencia_w, nr_seq_roteiro_w, nm_usuario_p);
		end;
	END loop;
	end;
	commit;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_inserir_cli_rot (nr_seq_cliente_p bigint, ds_lista_roteiro_p text, nm_usuario_p text) FROM PUBLIC;
