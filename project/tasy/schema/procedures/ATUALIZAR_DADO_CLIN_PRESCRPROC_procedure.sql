-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dado_clin_prescrproc ( nr_prescricao_p bigint, ds_lista_sequencias_p text, ds_dados_clinicos_p text, nm_usuario_p text) AS $body$
DECLARE


ds_lista_sequencias_w	varchar(2000);
nr_pos_virgula_w	bigint;
nr_sequencia_w		bigint;
cd_agenda_w		bigint;
nr_telefone_w		varchar(40);

BEGIN
if (ds_lista_sequencias_p IS NOT NULL AND ds_lista_sequencias_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ds_lista_sequencias_w	:= ds_lista_sequencias_p;

	while(ds_lista_sequencias_w IS NOT NULL AND ds_lista_sequencias_w::text <> '') loop
		begin
		nr_pos_virgula_w := position(',' in ds_lista_sequencias_w);

		if (nr_pos_virgula_w > 0) then
			begin
			nr_sequencia_w		:= substr(ds_lista_sequencias_w,0,nr_pos_virgula_w-1);
			ds_lista_sequencias_w	:= substr(ds_lista_sequencias_w,nr_pos_virgula_w+1,length(ds_lista_sequencias_w));
			end;
		else
			begin
			nr_sequencia_w		:= (ds_lista_sequencias_w)::numeric;
			ds_lista_sequencias_w	:= null;
			end;
		end if;

		if (coalesce(nr_sequencia_w,0) > 0) then
			begin
			update	prescr_procedimento
			set	ds_dado_clinico	= ds_dados_clinicos_p,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario	= nm_usuario_p
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia 	= nr_sequencia_w;
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
-- REVOKE ALL ON PROCEDURE atualizar_dado_clin_prescrproc ( nr_prescricao_p bigint, ds_lista_sequencias_p text, ds_dados_clinicos_p text, nm_usuario_p text) FROM PUBLIC;

