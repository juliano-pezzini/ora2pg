-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE philips_contabil_pck.inicializar () AS $body$
DECLARE

	cd_empresa_w		empresa.cd_empresa%type;
	cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
	
BEGIN
		cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
		cd_empresa_w		:= obter_empresa_estab(cd_estabelecimento_w);

		if (cd_empresa_w <> 0) then
			select	ie_sep_classif_conta_ctb,
				ie_sep_classif_centro
			into STRICT	current_setting('philips_contabil_pck.ie_sep_classif_conta_ctb_w')::empresa.ie_sep_classif_conta_ctb%type,
				current_setting('philips_contabil_pck.ie_sep_classif_centro_w')::empresa.ie_sep_classif_centro%type
			from	empresa	a
			where	a.cd_empresa	= cd_empresa_w;

			CALL philips_contabil_pck.set_separador_conta(current_setting('philips_contabil_pck.ie_sep_classif_conta_ctb_w')::empresa.ie_sep_classif_conta_ctb%type);
			CALL philips_contabil_pck.set_separador_centro(current_setting('philips_contabil_pck.ie_sep_classif_centro_w')::empresa.ie_sep_classif_centro%type);
		end if;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE philips_contabil_pck.inicializar () FROM PUBLIC;
