-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_duplic_reab_js ( cd_pessoa_fisica_p text, ie_insercao_p text, dt_referencia_p timestamp, ds_erro_p INOUT text, nr_sequencia_p INOUT bigint, ds_texto_p INOUT text, cd_estabelecimento_p bigint) AS $body$
DECLARE


ds_erro_w			varchar(100);
nr_sequencia_w			bigint;
ds_texto_w			varchar(100);
ie_perm_agendar_classif_w	varchar(80);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')then
	begin

	if (ie_insercao_p = 'S')then
		begin

		ds_erro_w  := rp_consistir_duplicidade_pac(cd_pessoa_fisica_p, cd_estabelecimento_p, ds_erro_w );

		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			begin
			CALL wheb_mensagem_pck.exibir_mensagem_abort(191116,'DS_ERRO='|| ds_erro_w);
			end;
		end if;


		ie_perm_agendar_classif_w := rp_obter_se_perm_pf_classif(9091, cd_pessoa_fisica_p, dt_referencia_p,'DS', 'N');

		if (ie_perm_agendar_classif_w <> '') then
			begin
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(71343,'IE_PERM_AGENDAR_CLASSIF='|| ie_perm_agendar_classif_w);
			end;
		end if;


		end;
	end if;



	select  max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from    rp_lista_espera_modelo
	where   cd_pessoa_fisica = cd_pessoa_fisica_p
	and     coalesce(nr_seq_modelo::text, '') = ''
	and     ie_status = 'A';

	ds_texto_w	:= obter_texto_tasy(57920, 1);

	end;
end if;

ds_erro_p	:= ds_erro_w;
nr_sequencia_p	:= nr_sequencia_w;
ds_texto_p	:= ds_texto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_duplic_reab_js ( cd_pessoa_fisica_p text, ie_insercao_p text, dt_referencia_p timestamp, ds_erro_p INOUT text, nr_sequencia_p INOUT bigint, ds_texto_p INOUT text, cd_estabelecimento_p bigint) FROM PUBLIC;

