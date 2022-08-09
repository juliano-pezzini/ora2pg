-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_tipo_sanguineo ( ie_tipo_p text, nr_seq_exame_lote_p bigint, nr_seq_exame_p bigint, nr_seq_producao_p bigint, ie_fator_rh_p text, ie_tipo_sangue_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_pergunta_p INOUT text) AS $body$
DECLARE

 
nr_seq_exame_rh_w		bigint;
nr_seq_exame_tipo_w		bigint;
ie_consistir_tipo_sangue_w	varchar(1);


BEGIN 
ie_consistir_tipo_sangue_w	:= 'S';
 
if (ie_tipo_p = 'H') then 
	begin 
	ie_consistir_tipo_sangue_w := 
		consistir_fator_rh_tipo_sangue( 
			nr_seq_exame_lote_p, 
			nr_seq_exame_p, 
			nr_seq_producao_p, 
			ie_tipo_p, 
			ie_fator_rh_p, 
			ie_tipo_sangue_p, 
			cd_estabelecimento_p);
	end;
 
elsif (ie_tipo_p = 'E') then 
	begin 
	select 	coalesce(max(nr_seq_exame_rh), 0), 
		coalesce(max(nr_seq_exame_tipo), 0) 
	into STRICT	nr_seq_exame_rh_w, 
		nr_seq_exame_tipo_w 
	from 	san_parametro 
	where 	cd_estabelecimento = cd_estabelecimento_p;
 
	if (nr_seq_exame_rh_w = nr_seq_exame_p) or (nr_seq_exame_tipo_w = nr_seq_exame_p) then 
		begin 
		ie_consistir_tipo_sangue_w := 
			consistir_fator_rh_tipo_sangue( 
				nr_seq_exame_lote_p, 
				nr_seq_exame_p, 
				nr_seq_producao_p, 
				ie_tipo_p, 
				ie_fator_rh_p, 
				ie_tipo_sangue_p, 
				cd_estabelecimento_p);
		end;
	end if;
	end;
end if;
 
if (ie_consistir_tipo_sangue_w = 'N') then 
	ds_pergunta_p	:= obter_texto_tasy(74173, wheb_usuario_pck.get_nr_seq_idioma);
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_tipo_sanguineo ( ie_tipo_p text, nr_seq_exame_lote_p bigint, nr_seq_exame_p bigint, nr_seq_producao_p bigint, ie_fator_rh_p text, ie_tipo_sangue_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_pergunta_p INOUT text) FROM PUBLIC;
