-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_data_guias ( ds_lista_data_p text, dt_liberacao_p timestamp, nm_usuario_p text) AS $body$
DECLARE


ds_lista_data_w		varchar(2000);
nr_pos_virgula_w	bigint;
nr_sequencia_w		bigint;
nr_controle_loop_w	smallint := 0;


BEGIN
if (ds_lista_data_p IS NOT NULL AND ds_lista_data_p::text <> '') and (dt_liberacao_p IS NOT NULL AND dt_liberacao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ds_lista_data_w := ds_lista_data_p;

	while(ds_lista_data_w IS NOT NULL AND ds_lista_data_w::text <> '') and (nr_controle_loop_w < 100) loop
		begin
		nr_pos_virgula_w := position(',' in ds_lista_data_w);

		if (nr_pos_virgula_w > 0) then
			begin
			nr_sequencia_w	:= (substr(ds_lista_data_w,0,nr_pos_virgula_w-1))::numeric;
			ds_lista_data_w	:= substr(ds_lista_data_w,nr_pos_virgula_w+1,length(ds_lista_data_w));
			end;
		else
			begin
			nr_sequencia_w	:= (ds_lista_data_w)::numeric;
			ds_lista_data_w	:= null;
			end;
		end if;

		if (nr_sequencia_w > 0) then
			begin
			update	pls_guia_plano_proc
			set	dt_liberacao = dt_liberacao_p,
				nm_usuario   = nm_usuario_p
			where   nr_sequencia = nr_sequencia_w;

			update	pls_guia_plano_mat
			set	dt_liberacao = dt_liberacao_p,
				nm_usuario   = nm_usuario_p
			where   nr_sequencia = nr_sequencia_w;
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
-- REVOKE ALL ON PROCEDURE pls_atualizar_data_guias ( ds_lista_data_p text, dt_liberacao_p timestamp, nm_usuario_p text) FROM PUBLIC;

