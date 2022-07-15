-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_acumular_saldo_bal (nm_usuario_p text) AS $body$
DECLARE


cd_empresa_w			bigint;
cd_estabelecimento_w		bigint;
cd_conta_contabil_w		varchar(40);
cd_classificacao_w		varchar(40);

vl_debito_w			double precision;
vl_credito_w			double precision;
vl_movimento_w		double precision;
vl_saldo_w			double precision;
vl_saldo_ant_w		double precision;

vl_movimento_ww		double precision;
vl_saldo_ww			double precision;
vl_saldo_ant_ww		double precision;

ie_deb_cre_w			varchar(01);
ie_deb_cre_ww			varchar(01);
ie_nivel_w			bigint;
k				integer;

C01 CURSOR FOR
SELECT
	cd_empresa,
	cd_estabelecimento,
	cd_conta_contabil,
	ie_nivel,
	cd_classificacao,
	vl_debito,
	vl_credito,
	vl_movimento,
	vl_saldo,
	vl_saldo_ant	
from	w_ctb_balancete a
where	ie_tipo		= 'A'
and	a.nm_usuario	= nm_usuario_p;
	


BEGIN

update w_ctb_balancete
set	vl_saldo_ant		= 0,
	vl_saldo		= 0,
	vl_movimento		= 0,
	vl_debito		= 0,
	vl_credito		= 0,
	dt_atualizacao	= clock_timestamp()
where	ie_tipo		= 'T'
and	nm_usuario		= nm_usuario_p;

OPEN C01;
LOOP
FETCH C01 into
	cd_empresa_w,
	cd_estabelecimento_w,
	cd_conta_contabil_w,
	ie_nivel_w,
	cd_classificacao_w,
	vl_debito_w,
	vl_credito_w,
	vl_movimento_w,
	vl_saldo_w,
	vl_saldo_ant_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	select	max(ie_debito_credito)
	into STRICT	ie_deb_cre_w
	from	ctb_grupo_conta b,
		conta_contabil a
	where	a.cd_conta_contabil	= cd_conta_contabil_w
	and	a.cd_grupo		= b.cd_grupo;

	k				:= ie_nivel_w - 1;
	WHILE k > 0 LOOP
		select	ctb_obter_classif_conta_sup(cd_classificacao_w, clock_timestamp(), cd_empresa_w)
		into STRICT	cd_classificacao_w
		;
		select	min(cd_conta_contabil)
		into STRICT	cd_conta_contabil_w
		from	conta_contabil a
		where 	cd_classificacao	= cd_classificacao_w
		and	cd_empresa		= cd_empresa_w;

		if (cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') then
			select	max(ie_debito_credito)
			into STRICT	ie_deb_cre_ww
			from	ctb_grupo_conta b,
				conta_contabil a
			where	a.cd_conta_contabil	= cd_conta_contabil_w
			and	a.cd_grupo		= b.cd_grupo;

			if (ie_deb_cre_w <> ie_deb_cre_ww) then
				vl_movimento_ww	:= vl_movimento_w * -1;
				vl_saldo_ww		:= vl_saldo_w * -1;
				vl_saldo_ant_ww	:= vl_saldo_ant_w * -1;
			else
				vl_movimento_ww	:= vl_movimento_w;
				vl_saldo_ww		:= vl_saldo_w;
				vl_saldo_ant_ww	:= vl_saldo_ant_w;
			end if;
			
			if (vl_debito_w > 0 or vl_credito_w > 0) then
				if (ie_deb_cre_w = 'D') then
					vl_movimento_ww := vl_debito_w - vl_credito_w;
				else
					vl_movimento_ww := vl_credito_w - vl_debito_w;
				end if;
			end if;
		
			update w_ctb_balancete
			SET	vl_debito		= vl_debito + vl_debito_w,
				vl_credito 		= vl_credito + vl_credito_w,
				vl_movimento		= vl_movimento + vl_movimento_ww,
				vl_saldo_ant		= vl_saldo_ant + vl_saldo_ant_ww,
				vl_saldo		= vl_saldo + vl_saldo_ww,
				dt_atualizacao	= clock_timestamp()
			where	cd_empresa		= cd_empresa_w
			and	cd_estabelecimento	= cd_estabelecimento_w
			and	cd_conta_contabil	= cd_conta_contabil_w
			and	nm_usuario		= nm_usuario_p;
		end if;
		K	:= K - 1;
	END LOOP;
END LOOP;
CLOSE C01;
commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_acumular_saldo_bal (nm_usuario_p text) FROM PUBLIC;

