-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_paciente_debito ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, ie_gerar_comunic_p text, nm_usuario_p text, ie_opcao_alerta_p INOUT text, ds_mensagem_p INOUT text, cd_perfil_comunic_p INOUT bigint, cd_pessoa_comunic_p INOUT text, nr_atendimento_p bigint) AS $body$
DECLARE

 
qt_regra_w		bigint;
nr_seq_classif_w		bigint;
nr_sequencia_w		bigint;
qt_dias_debito_w		bigint := 0;
vl_debito_w		double precision := 0;
ie_exibir_alerta_w		varchar(5) := null;
ie_opcao_alerta_w		varchar(5) := 'S';
ds_mensagem_w		varchar(4000) := null;
ds_titulos_debito_w		varchar(4000) := null;
nr_titulo_w		bigint := null;
vl_saldo_aberto_w		double precision := 0;
cd_perfil_w		bigint := null;
cd_pessoa_aviso_w	varchar(10) := null;
nm_usuarios_aviso_w	varchar(4000) := '';
nr_seq_cheque_w		bigint;
nr_cheque_w		varchar(20);
ds_cheques_devolvidos_w	varchar(4000) := null;
vl_cheques_devolvidos_w	double precision := 0;
vl_saldo_titulo_w		double precision := 0;
vl_cheque_w		double precision := 0;
ie_valor_pendente_w	varchar(1);
ie_pendente_w		varchar(1);
ie_restringe_estab_w	varchar(1);

ie_encontrou_regra_w	varchar(1) := 'N';
cd_estabelecimento_w	smallint;
nm_usuario_atend_w	varchar(15);
ds_perfil_aviso_w		varchar(4000);	
nr_seq_grupo_prod_w	bigint;
cd_tipo_portado_w		integer;

vl_perda_w		double precision;
vl_total_perda_w		double precision	:= 0;

ie_valores_perda_w		varchar(1);
cd_portador_w		bigint;
ie_exibir_valor_debito_w	regra_alerta_debito_pac.ie_exibir_valor_debito%type;

c01 CURSOR FOR 
SELECT	nr_sequencia, 
	ie_exibir_alerta, 
	qt_dias_debito, 
	vl_debito, 
	cd_perfil, 
	cd_pessoa_aviso, 
	cd_estabelecimento, 
	ie_valor_pendente, 
	coalesce(nr_seq_grupo_prod,0), 
	coalesce(cd_tipo_portador,0), 
	coalesce(cd_portador,0), 
	coalesce(ie_exibir_valor_debito,'S') 
from	regra_alerta_debito_pac 
where	dt_inicio_vigencia 				< clock_timestamp() 
and	coalesce(dt_final_vigencia,clock_timestamp() + interval '1 days')		> clock_timestamp() 
and	coalesce(cd_pessoa_fisica,cd_pessoa_fisica_p)	= cd_pessoa_fisica_p 
and	coalesce(nr_seq_classif,nr_seq_classif_w)		= nr_seq_classif_w 
and	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0))	= coalesce(cd_estabelecimento_p,0) 
order	by coalesce(cd_pessoa_fisica,'0'), 
	coalesce(nr_seq_classif,0);

/* títulos em aberto */
 
c02 CURSOR FOR 
SELECT 	a.nr_titulo, 
	a.vl_saldo_titulo 
from  	valores_pendentes_v a 
where 	a.cd_pessoa_fisica 	= cd_pessoa_fisica_p 
and (trunc(clock_timestamp(), 'dd') - trunc(dt_pagamento_previsto, 'dd')) >= qt_dias_debito_w 
and	((coalesce(ie_pendente_w,'N') = 'N') or (coalesce(ie_pendente_w,'N') = 'S' and trunc(a.dt_pagamento_previsto) < trunc(clock_timestamp()))) 
and	((coalesce(ie_restringe_estab_w,'N') = 'N') or (coalesce(ie_restringe_estab_w,'N') = 'S' and coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0) or obter_estab_financeiro(a.cd_estabelecimento) = coalesce(cd_estabelecimento_p,0))) 
and	(a.nr_titulo IS NOT NULL AND a.nr_titulo::text <> '') 
and (obter_grupo_prod_financ(a.nr_seq_produto,1) = nr_seq_grupo_prod_w or nr_seq_grupo_prod_w = 0) 
 
and (a.cd_tipo_portador = cd_tipo_portado_w or cd_tipo_portado_w = 0) 
and (a.cd_portador = cd_portador_w or cd_portador_w = 0) 
order by 1;

/* francisco - os 70990 - 19/10/2007 - cheques devolvidos */
 
c03 CURSOR FOR 
SELECT	a.nr_cheque, 
	a.vl_cheque 
from  valores_pendentes_v a 
where  a.cd_pessoa_fisica = cd_pessoa_fisica_p 
and	(a.nr_seq_cheque IS NOT NULL AND a.nr_seq_cheque::text <> '') 
and	((coalesce(ie_restringe_estab_w,'N') = 'N') or (coalesce(ie_restringe_estab_w,'N') = 'S' and coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0))) 
and (coalesce(obter_grupo_prod_financ(a.nr_seq_produto,1),'0')	= coalesce(nr_seq_grupo_prod_w,'0') or 
	 coalesce(nr_seq_grupo_prod_w,'0') = '0') 
and	coalesce(a.cd_tipo_portador,coalesce(cd_tipo_portado_w,0))		= coalesce(cd_tipo_portado_w,0)	 
and	coalesce(a.cd_portador,coalesce(cd_portador_w,0))		= coalesce(cd_portador_w,0) 
order by 1;


BEGIN 
 
ie_pendente_w := obter_param_usuario(916, 88, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_pendente_w);
ie_restringe_estab_w := obter_param_usuario(-815, 2, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_restringe_estab_w);
ie_valores_perda_w := obter_param_usuario(-815, 8, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_valores_perda_w);
 
select	coalesce(max(nr_seq_classif), 0) 
into STRICT	nr_seq_classif_w 
from	pessoa_classif 
where	cd_pessoa_fisica			= cd_pessoa_fisica_p 
and	dt_inicio_vigencia			< clock_timestamp() 
and	coalesce(dt_final_vigencia,clock_timestamp() + interval '1 days')	> clock_timestamp();
 
select	max(a.nm_usuario) 
into STRICT	nm_usuario_atend_w 
from	atendimento_paciente a 
where	a.nr_atendimento	= nr_atendimento_p;
 
open c01;
loop 
fetch c01 into 
	nr_sequencia_w, 
	ie_exibir_alerta_w, 
	qt_dias_debito_w, 
	vl_debito_w, 
	cd_perfil_w, 
	cd_pessoa_aviso_w, 
	cd_estabelecimento_w, 
	ie_valor_pendente_w, 
	nr_seq_grupo_prod_w, 
	cd_tipo_portado_w, 
	cd_portador_w, 
	ie_exibir_valor_debito_w;
EXIT WHEN NOT FOUND; /* apply on c01 */	
	ie_encontrou_regra_w	:= 'S';
	nm_usuarios_aviso_w 	:= nm_usuarios_aviso_w || substr(obter_usuario_pessoa(cd_pessoa_aviso_w),1,20) || ', ';
 
	if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then 
		ds_perfil_aviso_w		:= ds_perfil_aviso_w || cd_perfil_w || ', ';
	end if;
end loop;
close c01;
 
if (ie_encontrou_regra_w = 'S') then 
 
	open c02;
	loop 
	fetch c02 into 
		nr_titulo_w, 
		vl_saldo_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */		
		ds_titulos_debito_w	:= nr_titulo_w || ', ' || ds_titulos_debito_w;
		vl_saldo_aberto_w	:= vl_saldo_aberto_w + vl_saldo_titulo_w;
	end loop;
	close c02;
	 
	/* francisco - os 70990 - 19/10/2007 - deve alertar tambem cheques devolvidos */
 
	open c03;
	loop 
	fetch c03 into 
		nr_cheque_w, 
		vl_cheque_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		ds_cheques_devolvidos_w	:= nr_cheque_w || ', ' || ds_cheques_devolvidos_w;
		vl_cheques_devolvidos_w	:= vl_cheques_devolvidos_w + vl_cheque_w;
	end loop;
	close c03;
	 
	vl_total_perda_w	:= 0;
	 
	if (ie_valores_perda_w = 'S') then 
		begin 
		if (coalesce(ie_restringe_estab_w,'N') = 'N') then 
			select	coalesce(sum(a.vl_saldo_perda),0) 
			into STRICT	vl_total_perda_w 
			from  valores_pendentes_v a 
			where  a.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and	(a.nr_seq_perda IS NOT NULL AND a.nr_seq_perda::text <> '');
		else 
			select	coalesce(sum(a.vl_saldo_perda),0) 
			into STRICT	vl_total_perda_w 
			from  valores_pendentes_v a 
			where  a.cd_pessoa_fisica = cd_pessoa_fisica_p 
			and	(a.nr_seq_perda IS NOT NULL AND a.nr_seq_perda::text <> '') 
			and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0);
		end if;
		end;
	end if;
		 
	if (ie_exibir_alerta_w <> 'N') and 
		((vl_saldo_aberto_w + vl_cheques_devolvidos_w + vl_total_perda_w) > vl_debito_w) then 
		if (ds_titulos_debito_w IS NOT NULL AND ds_titulos_debito_w::text <> '') or (ds_cheques_devolvidos_w IS NOT NULL AND ds_cheques_devolvidos_w::text <> '') or (coalesce(vl_total_perda_w,0) <> 0) then 
			ds_mensagem_w	:= wheb_mensagem_pck.get_texto(303149,'NM_PACIENTE=' || substr(obter_nome_pf(cd_pessoa_fisica_p),1,60));
			/*'O paciente ' || obter_nome_pf(cd_pessoa_fisica_p) || ' está dando entrada no hospital ';*/
 
		end if;
 
		if (ds_titulos_debito_w IS NOT NULL AND ds_titulos_debito_w::text <> '') then 
			ds_mensagem_w := ds_mensagem_w || wheb_mensagem_pck.get_texto(303150,'DS_TIT_ABERTO=' || ds_titulos_debito_w);
			/*ds_mensagem_w := ds_mensagem_w || ' com o(s) título(s) ' || ds_titulos_debito_w || 
					' em débito';*/
 
			if (coalesce(ie_exibir_valor_debito_w,'S') = 'S') then 
				ds_mensagem_w	:= ds_mensagem_w || wheb_mensagem_pck.get_texto(303151,'VALOR=' || substr(campo_mascara_virgula(vl_saldo_aberto_w),1,20));
				/*', somando o valor de R$' || substr(campo_mascara_virgula(vl_saldo_aberto_w),1,20);*/
 
			end if;
		end if;
 
		if (ds_cheques_devolvidos_w IS NOT NULL AND ds_cheques_devolvidos_w::text <> '') then 
			if (ds_titulos_debito_w IS NOT NULL AND ds_titulos_debito_w::text <> '') then 
				ds_mensagem_w	:= ds_mensagem_w || ' e ';
			end if;
 
			ds_mensagem_w := ds_mensagem_w || wheb_mensagem_pck.get_texto(303153) || ds_cheques_devolvidos_w || 
					wheb_mensagem_pck.get_texto(303154);
			if (coalesce(ie_exibir_valor_debito_w,'S') = 'S') then 
				ds_mensagem_w	:= ds_mensagem_w || wheb_mensagem_pck.get_texto(303151,'VALOR=' || substr(campo_mascara_virgula(vl_cheques_devolvidos_w),1,20));
			end if;
		end if;
		 
		if (vl_total_perda_w > 0) then 
			if (ds_titulos_debito_w IS NOT NULL AND ds_titulos_debito_w::text <> '') or (ds_cheques_devolvidos_w IS NOT NULL AND ds_cheques_devolvidos_w::text <> '') then 
				ds_mensagem_w	:= ds_mensagem_w || ' e ';
			end if;
			/*' com outros débitos em aberto'*/
 
			ds_mensagem_w := ds_mensagem_w || wheb_mensagem_pck.get_texto(303155);
			if (coalesce(ie_exibir_valor_debito_w,'S') = 'S') then 
				ds_mensagem_w	:= ds_mensagem_w || wheb_mensagem_pck.get_texto(303156,'VALOR=' || substr(campo_mascara_virgula(vl_total_perda_w),1,20));
				/*' no valor total de R$' || substr(campo_mascara_virgula(vl_total_perda_w),1,20);*/
 
			end if;
		end if;
 
		ds_mensagem_w	:= ds_mensagem_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(303157) || nr_atendimento_p || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(303158) || coalesce(nm_usuario_atend_w,nm_usuario_p);
	end if;
 
	ie_opcao_alerta_w	:= ie_exibir_alerta_w;
 
	if (coalesce(ie_valor_pendente_w,'N') = 'S') and (coalesce(ds_titulos_debito_w::text, '') = '') and (coalesce(ds_cheques_devolvidos_w::text, '') = '') and (vl_total_perda_w = 0) then 
		ie_opcao_alerta_w	:= 'N';
	end if;
 
	if (ie_gerar_comunic_p = 'S') and (ie_exibir_alerta_w in ('C', 'R', 'J')) and (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') then 
 
		CALL gerar_comunic_padrao(	clock_timestamp(), 
					wheb_mensagem_pck.get_texto(303159), 
					ds_mensagem_w, 
					'Tasy', 
					'N', 
					nm_usuarios_aviso_w, 
					'N', 
					null, 
					ds_perfil_aviso_w, 
					cd_estabelecimento_w, 
					null, 
					clock_timestamp(), 
					null, 
					null);
	end if;
 
end if;	
 
 
ie_opcao_alerta_p		:= ie_opcao_alerta_w;
cd_perfil_comunic_p	:= cd_perfil_w;
cd_pessoa_comunic_p	:= cd_pessoa_aviso_w;
ds_mensagem_p		:= substr(ds_mensagem_w,1,255);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_paciente_debito ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, ie_gerar_comunic_p text, nm_usuario_p text, ie_opcao_alerta_p INOUT text, ds_mensagem_p INOUT text, cd_perfil_comunic_p INOUT bigint, cd_pessoa_comunic_p INOUT text, nr_atendimento_p bigint) FROM PUBLIC;
