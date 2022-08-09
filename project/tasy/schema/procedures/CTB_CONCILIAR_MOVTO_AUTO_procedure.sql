-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_conciliar_movto_auto ( nr_seq_concil_p ctb_movimento.nr_sequencia%type, cd_conta_contabil_p ctb_saldo.cd_conta_contabil%type, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_mes_ref_w	ctb_registro_concil.nr_seq_mes_ref%type;
cd_conta_contabil_w	ctb_saldo.cd_conta_contabil%type;
nr_documento_w		ctb_movimento.nr_documento%type;
ie_origem_documento_w	ctb_movimento.ie_origem_documento%type;
vl_debito_w		ctb_movimento.vl_movimento%type;
vl_credito_w		ctb_movimento.vl_movimento%type;
dt_referencia_w		timestamp;
dt_fim_mes_w		timestamp;

 
c01 CURSOR FOR 
SELECT	c.cd_conta_contabil 
from	ctb_balancete_v c 
where	c.nr_seq_mes_ref	= nr_seq_mes_ref_w 
and	c.cd_conta_contabil	= coalesce(cd_conta_contabil_p, c.cd_conta_contabil) 
and	exists (SELECT	1 
		from	ctb_registro_concil a, 
			ctb_registro_concil_conta b 
		where	a.nr_sequencia = nr_seq_concil_p 
		and	a.nr_sequencia = b.nr_seq_reg_concil 
		and	b.cd_conta_contabil = c.cd_conta_contabil) 
group by cd_conta_contabil;

c02 CURSOR FOR 
SELECT	a.nr_documento, 
	a.ie_origem_documento, 
	coalesce(sum(a.vl_debito),0) vl_debito, 
	coalesce(sum(a.vl_credito),0) vl_credito 
from	ctb_movimento_v2 a 
where	a.cd_conta_contabil = cd_conta_contabil_w 
and	a.dt_movimento <= dt_fim_mes_w 
and	coalesce(a.ie_status_concil, 'NC') in ('NC', 'PC') 
group by a.nr_documento, a.ie_origem_documento;
					

BEGIN 
 
select	nr_seq_mes_ref 
into STRICT	nr_seq_mes_ref_w 
from	ctb_registro_concil 
where	nr_sequencia = nr_seq_concil_p;
 
dt_referencia_w	:= ctb_obter_mes_ref(nr_seq_mes_ref_w);
 
dt_fim_mes_w	:= fim_mes(dt_referencia_w);
 
open c01;
loop 
fetch c01 into 
	cd_conta_contabil_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin	 
	 
	open c02;
	loop 
	fetch c02 into 			 
		nr_documento_w,	 
		ie_origem_documento_w,		 
		vl_debito_w, 
		vl_credito_w;		
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin	 
		 
		if (vl_debito_w = vl_credito_w) then		 
			update	ctb_movimento a 
			set	a.ie_status_concil	= 'C', 
				a.dt_atualizacao	= clock_timestamp(), 
				a.nm_usuario		= nm_usuario_p				 
			where	a.nr_documento		= nr_documento_w 
			and	a.ie_origem_documento	= ie_origem_documento_w 
			and	a.dt_movimento		<= dt_fim_mes_w 
			and (a.cd_conta_credito	= cd_conta_contabil_w 
			or	a.cd_conta_debito	= cd_conta_contabil_w); 		
		elsif (vl_debito_w != 0 and vl_credito_w != 0) then 		 
			update	ctb_movimento a 
			set	a.ie_status_concil	= 'PC', 
				a.dt_atualizacao	= clock_timestamp(), 
				a.nm_usuario		= nm_usuario_p				 
			where	a.nr_documento		= nr_documento_w 
			and	a.ie_origem_documento	= ie_origem_documento_w 
			and	a.dt_movimento		<= dt_fim_mes_w 
			and (a.cd_conta_credito	= cd_conta_contabil_w 
			or	a.cd_conta_debito	= cd_conta_contabil_w); 			
		end if;
		 
		end;		
	END LOOP;
	CLOSE c02;	
	 
	end;
END LOOP;
CLOSE C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_conciliar_movto_auto ( nr_seq_concil_p ctb_movimento.nr_sequencia%type, cd_conta_contabil_p ctb_saldo.cd_conta_contabil%type, nm_usuario_p text) FROM PUBLIC;
