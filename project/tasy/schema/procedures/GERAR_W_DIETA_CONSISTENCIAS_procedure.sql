-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_dieta_consistencias ( nr_prescricao_p bigint, nr_seq_consistencia_p bigint, ds_lista_composicao_p text, nm_usuario_p text) AS $body$
DECLARE


ds_lista_composicao_w	varchar(2000);
nr_seq_composicao_w	bigint;
nr_pos_virgula_w	bigint;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_consistencia_p IS NOT NULL AND nr_seq_consistencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ds_lista_composicao_w	:= ds_lista_composicao_p;

	while(ds_lista_composicao_w IS NOT NULL AND ds_lista_composicao_w::text <> '') loop
		begin
		nr_pos_virgula_w	:=	position(',' in ds_lista_composicao_w);
		if (nr_pos_virgula_w > 0) then
			begin
			nr_seq_composicao_w	:= (substr(ds_lista_composicao_w,0,nr_pos_virgula_w-1))::numeric;
			ds_lista_composicao_w	:= substr(ds_lista_composicao_w,nr_pos_virgula_w+1,length(ds_lista_composicao_w));
			end;
		else
			begin
			nr_seq_composicao_w	:= (ds_lista_composicao_w)::numeric;
			ds_lista_composicao_w	:= null;
			end;
		end if;

		if (coalesce(nr_seq_composicao_w,0) > 0) then
			begin
			CALL gerar_w_dieta_consistencia(
				nr_prescricao_p,
				nr_seq_consistencia_p,
				nr_seq_composicao_w,
				nm_usuario_p);
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
-- REVOKE ALL ON PROCEDURE gerar_w_dieta_consistencias ( nr_prescricao_p bigint, nr_seq_consistencia_p bigint, ds_lista_composicao_p text, nm_usuario_p text) FROM PUBLIC;

