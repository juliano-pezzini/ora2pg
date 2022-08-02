-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_lib_repasses ( ds_repasses_mens_p text, nm_usuario_p text ) AS $body$
DECLARE


ds_repasses_mens_w		varchar(1000);		/* Conjunto de identificadores de repasses */
ie_pos_virgula_w			smallint;		/* posicao da virgula */
tam_lista_w			bigint;		/* tamanha da lista de ds_repasses_mens_w */
nr_seq_repasse_mens_w		bigint;		/* identificador atual */
nr_controle_loop_w			smallint := 0;		/* controle do loop */
BEGIN
if (ds_repasses_mens_p IS NOT NULL AND ds_repasses_mens_p::text <> '') then
	begin
	ds_repasses_mens_w 	:= ds_repasses_mens_p;

	while(ds_repasses_mens_w IS NOT NULL AND ds_repasses_mens_w::text <> '') and (nr_controle_loop_w < 100) loop
		begin
		tam_lista_w		:= length(ds_repasses_mens_w);
		ie_pos_virgula_w	:= position(',' in ds_repasses_mens_w);
		nr_seq_repasse_mens_w	:= 0;

		if (ie_pos_virgula_w <> 0) then
			begin
			nr_seq_repasse_mens_w	:= (substr(ds_repasses_mens_w,1,(ie_pos_virgula_w - 1)))::numeric;
			ds_repasses_mens_w	:= substr(ds_repasses_mens_w,(ie_pos_virgula_w + 1),tam_lista_w);
			end;
		else
			begin
			nr_seq_repasse_mens_w	:= (ds_repasses_mens_w)::numeric;
			ds_repasses_mens_w	:= null;
			end;
		end if;

		if (coalesce(nr_seq_repasse_mens_w,0) > 0) then
			begin
			CALL pls_desfazer_lib_repasse(nr_seq_repasse_mens_w, nm_usuario_p);
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
-- REVOKE ALL ON PROCEDURE pls_desfazer_lib_repasses ( ds_repasses_mens_p text, nm_usuario_p text ) FROM PUBLIC;

