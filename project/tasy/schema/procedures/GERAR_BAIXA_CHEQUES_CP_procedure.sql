-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_baixa_cheques_cp (ds_lista_cheques_p text, nr_tit_pagar_p bigint, cd_tipo_baixa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_juros_multa_p text) AS $body$
DECLARE

 
 
vl_cheque_w		double precision;
nr_seq_trans_financ_w	bigint;
vl_baixa_w		double precision;
vl_saldo_tit_w		double precision;
nr_seq_baixa_w		bigint;
nr_seq_conta_banco_w	bigint;
dt_emissao_w		timestamp;
qt_cheques_w		bigint;
vl_juros_w		double precision;
vl_multa_w		double precision;
ie_gerar_banco_w	varchar(255);
nr_cheque_w		varchar(15);
nr_seq_alteracao_w	bigint;
dt_vencimento_w		timestamp;
ie_alterar_venc_w	varchar(1);
nr_seq_cheque_cp_w	bigint;
nr_seq_trans_fin_emissao_w bigint;
cd_tipo_baixa_w	integer;

c01 CURSOR FOR 
SELECT	vl_cheque, 
	nr_seq_conta_banco, 
	dt_emissao, 
	nr_cheque, 
	coalesce(dt_vencimento,dt_emissao), 
	nr_sequencia 
from	cheque 
where	' ' || ds_lista_cheques_p || ' ' like '% ' || nr_sequencia || ' %' 
and	(ds_lista_cheques_p IS NOT NULL AND ds_lista_cheques_p::text <> '') 
order by dt_emissao;

c02 CURSOR FOR 
SELECT	nr_sequencia 
from	titulo_pagar_baixa 
where	nr_titulo	= nr_tit_pagar_p;


BEGIN 
 
ie_gerar_banco_w := Obter_Param_Usuario(851, 94, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_banco_w);	
ie_alterar_venc_w := Obter_Param_Usuario(851, 175, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_alterar_venc_w);	
 
select	nr_seq_trans_fin_baixa, 
	vl_saldo_titulo 
into STRICT	nr_seq_trans_financ_w, 
	vl_saldo_tit_w 
from	titulo_pagar 
where	nr_titulo	= nr_tit_pagar_p;
 
if (coalesce(nr_seq_trans_financ_w::text, '') = '') then 
 
	if (philips_param_pck.get_cd_pais = 2) then 
	 
		select	max(nr_seq_trans_fin_emissao) 
		into STRICT 	nr_seq_trans_fin_emissao_w 
		from	cheque 
		where	' ' || ds_lista_cheques_p || ' ' like '% ' || nr_sequencia || ' %' 
		and		(ds_lista_cheques_p IS NOT NULL AND ds_lista_cheques_p::text <> '') 
		order by dt_emissao;
		 
		if (nr_seq_trans_fin_emissao_w IS NOT NULL AND nr_seq_trans_fin_emissao_w::text <> '') then 
		 
			select cd_tipo_baixa 
			into STRICT  cd_tipo_baixa_w 
			from  transacao_financeira 
			where nr_sequencia = nr_seq_trans_fin_emissao_w;
			 
			if (cd_tipo_baixa_w IS NOT NULL AND cd_tipo_baixa_w::text <> '') then 
			 
				select	nr_seq_trans_fin 
				into STRICT	nr_seq_trans_financ_w 
				from	tipo_baixa_cpa 
				where	cd_tipo_baixa = cd_tipo_baixa_w;	
				 
			end if;			
		end if;				
	end if;	
		 
	if (coalesce(nr_seq_trans_financ_w::text, '') = '') then 
		select	nr_seq_trans_fin 
		into STRICT	nr_seq_trans_financ_w 
		from	tipo_baixa_cpa 
		where	cd_tipo_baixa = cd_tipo_baixa_p;
	end if;
 
end if;
 
open c01;
loop 
fetch c01 into 
	vl_cheque_w, 
	nr_seq_conta_banco_w, 
	dt_emissao_w, 
	nr_cheque_w, 
	dt_vencimento_w, 
	nr_seq_cheque_cp_w;
EXIT WHEN NOT FOUND; /* apply on c01 */	
 
	if (vl_saldo_tit_w >= vl_cheque_w) then 
		vl_baixa_w := vl_cheque_w;
	else 
		vl_baixa_w := vl_saldo_tit_w;
	end if;
 
 
	CALL Baixa_Titulo_Pagar(	cd_estabelecimento_p, 
				coalesce(cd_tipo_baixa_w,cd_tipo_baixa_p), 
				nr_tit_pagar_p, 
				vl_baixa_w, 
				nm_usuario_p, 
				nr_seq_trans_financ_w, 
				null, 
				null, 
				dt_emissao_w, 
				nr_seq_conta_banco_w, 
				nr_seq_cheque_cp_w);
 
	if (coalesce(ie_alterar_venc_w,'N')	= 'S') and (dt_vencimento_w IS NOT NULL AND dt_vencimento_w::text <> '') then 
 
		CALL alterar_venc_titulo(	nr_tit_pagar_p, 
					dt_vencimento_w, 
					'CP', 
					clock_timestamp(), 
					null, 
					null, 
					null, 
					null, 
					null, 
					nm_usuario_p, 
					wheb_mensagem_pck.get_texto(303794, 'NR_CHEQUE_W=' || nr_cheque_w));
 
		select	max(a.nr_sequencia) 
		into STRICT	nr_seq_alteracao_w 
		from	titulo_pagar_alt_venc a 
		where	a.nr_titulo	= nr_tit_pagar_p;
 
		CALL atualizar_venc_titulo_imposto(	nr_tit_pagar_p, 
						nr_seq_alteracao_w, 
						nm_usuario_p);
 
	end if;
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_baixa_w 
	from	titulo_pagar_baixa 
	where	nr_titulo	= nr_tit_pagar_p;
 
	update	titulo_pagar_baixa 
	set	nr_seq_cheque_cp	= nr_seq_cheque_cp_w 
	where	nr_titulo		= nr_tit_pagar_p 
	and	nr_sequencia		= nr_seq_baixa_w;	
 
	if (ie_juros_multa_p = 'S') then 
 
		select	count(*) 
		into STRICT	qt_cheques_w 
		from	cheque 
		where	ds_lista_cheques_p like '% ' || nr_sequencia || ' %' 
		and	(ds_lista_cheques_p IS NOT NULL AND ds_lista_cheques_p::text <> '');
 
		/* So atualizar juros e multa quando 1 cheque s?? */
 
		if (qt_cheques_w = 1) then 
			select	coalesce(obter_juros_multa_titulo(nr_tit_pagar_p,clock_timestamp(),'P','J'),0), 
				coalesce(obter_juros_multa_titulo(nr_tit_pagar_p,clock_timestamp(),'P','M'),0) 
			into STRICT	vl_juros_w, 
				vl_multa_w 
			;
 
			update	titulo_pagar_baixa 
			set	vl_juros	= vl_juros_w, 
				vl_multa	= vl_multa_w 
			where	nr_titulo	= nr_tit_pagar_p 
			and	nr_sequencia	= nr_seq_baixa_w;
		end if;
	end if;
 
	if (ie_gerar_banco_w = 'S') then 
		begin 
		CALL GERAR_MOVTO_TIT_BAIXA(	nr_tit_pagar_p, 
				nr_seq_baixa_w, 
				'P', 
				nm_usuario_p,'N');
		end;
	end if;
	 
end loop;
close c01;
 
CALL Atualizar_Saldo_Tit_Pagar(nr_tit_pagar_p, nm_usuario_p);
CALL Gerar_W_Tit_Pag_imposto(nr_tit_pagar_p, nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_baixa_cheques_cp (ds_lista_cheques_p text, nr_tit_pagar_p bigint, cd_tipo_baixa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_juros_multa_p text) FROM PUBLIC;
