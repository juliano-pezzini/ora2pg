-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_se_regra_atrib ( nr_seq_trans_fin_p bigint, cd_tipo_lote_contabil_p bigint, nm_atributo_p text, dt_documento_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_gerar_w				varchar(1)	:= 'N';


BEGIN

if (cd_tipo_lote_contabil_p = 2) then
	ie_gerar_w	:= 'S';
else
	begin
	if (coalesce(nr_seq_trans_fin_p,0) != 0) and (nm_atributo_p IS NOT NULL AND nm_atributo_p::text <> '') then
		
		select	coalesce(max('S'),'N')
		into STRICT	ie_gerar_w
		
		where	exists (	SELECT	1
				from	trans_financ_contab a
				where	a.nr_seq_trans_financ	= nr_seq_trans_fin_p
				and	a.nm_atributo		= nm_atributo_p
				and	obter_se_periodo_vigente(a.dt_inicio_vigencia,a.dt_fim_vigencia,dt_documento_p) = 'S');
				
		if (ie_gerar_w = 'N') and (nm_atributo_p = 'VL_TRANSACAO') and (cd_tipo_lote_contabil_p in (10,18)) then
			begin
			select	CASE WHEN cd_tipo_lote_contabil_p=10 THEN coalesce(a.ie_contab_tesouraria,'N') WHEN cd_tipo_lote_contabil_p=18 THEN coalesce(a.ie_contab_banco,'N') END
			into STRICT	ie_gerar_w
			from	transacao_financeira a
			where	a.nr_sequencia	= nr_seq_trans_fin_p;
			exception when others then
				ie_gerar_w	:= 'N';
			end;
		end if;
		

	end if;
	end;
end if;

return ie_gerar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_se_regra_atrib ( nr_seq_trans_fin_p bigint, cd_tipo_lote_contabil_p bigint, nm_atributo_p text, dt_documento_p timestamp) FROM PUBLIC;

