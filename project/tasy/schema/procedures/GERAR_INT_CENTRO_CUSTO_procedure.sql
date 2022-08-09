-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_int_centro_custo ( nr_seq_centro_custo_p bigint, nm_usuario_p text, ie_status_p INOUT text, ds_erro_p INOUT text) AS $body$
DECLARE




qt_registros_w				bigint;
ie_status_w				varchar(15);
ds_erro_w				varchar(2000);
nr_sequencia_int_w				w_int_centro_custo.nr_sequencia%type;
ds_centro_custo_int_w			w_int_centro_custo.ds_centro_custo%type;
ie_situacao_int_w				w_int_centro_custo.ie_situacao%type;
cd_classificacao_int_w			w_int_centro_custo.cd_classificacao%type;
cd_grupo_int_w				w_int_centro_custo.cd_grupo%type;
cd_estabelecimento_int_w			w_int_centro_custo.cd_estabelecimento%type;
ie_tipo_int_w				w_int_centro_custo.ie_tipo%type;
ie_tipo_custo_int_w				w_int_centro_custo.ie_tipo_custo%type;
ie_periodo_proj_receita_int_w			w_int_centro_custo.ie_periodo_proj_receita%type;
cd_sistema_contabil_int_w			w_int_centro_custo.cd_sistema_contabil%type;
ds_observacao_int_w			w_int_centro_custo.ds_observacao%type;
cd_centro_custo_w				centro_custo.cd_centro_custo%type;
cd_estab_tasy_w				estabelecimento.cd_estabelecimento%type;
cd_grupo_tasy_w				ctb_grupo_centro.cd_grupo%type;




BEGIN

ie_status_w	:= 'OK';

select	count(*)
into STRICT	qt_registros_w
from	w_int_centro_custo
where	nr_sequencia = nr_seq_centro_custo_p;

if (qt_registros_w > 0) then

	select 	nr_sequencia,
		ds_centro_custo,
		coalesce(ie_situacao,'A'),
		cd_classificacao,
		cd_grupo,
		cd_estabelecimento,
		coalesce(ie_tipo,'A'),
		ie_tipo_custo,
		coalesce(ie_periodo_proj_receita,'U'),
		cd_sistema_contabil,
		ds_observacao
	into STRICT	nr_sequencia_int_w,
		ds_centro_custo_int_w,
		ie_situacao_int_w,
		cd_classificacao_int_w,
		cd_grupo_int_w,
		cd_estabelecimento_int_w,
		ie_tipo_int_w,
		ie_tipo_custo_int_w,
		ie_periodo_proj_receita_int_w,
		cd_sistema_contabil_int_w,
		ds_observacao_int_w
	from 	w_int_centro_custo
	where	nr_sequencia = nr_seq_centro_custo_p;
else
	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450325,'NR_SEQUENCIA_W=' || NR_SEQ_CENTRO_CUSTO_P);/*Não existe nenhum registro na tabela de centro de custos com o código #@NR_SEQUENCIA_W#@.*/
end if;



/*DS_CENTRO_CUSTO*/

if (ie_status_w = 'OK') and (coalesce(ds_centro_custo_int_w::text, '') = '') then
	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450326);/*Favor informar descrição do centro de custo. Campo obrigatório.*/
end if;



/*IE_SITUACAO*/

if (ie_status_w = 'OK') and (coalesce(ie_situacao_int_w::text, '') = '') then

	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450327);/*Favor informar a situação do centro de custo. Campo obrigatório.*/
else
	if (ie_situacao_int_w not in ('A','I')) then

		ie_status_w	:= 'E';
		ds_erro_w	:= wheb_mensagem_pck.get_Texto(450328);/*Favor informar um valor válido para a situação do centro de custo (A para a situação ativa, I para a situação inativa).*/
	end if;
end if;



/*CD_GRUPO*/

if (ie_status_w = 'OK') and (cd_grupo_int_w IS NOT NULL AND cd_grupo_int_w::text <> '') then


	select	coalesce(somente_numero(bkf_obter_conv_interna('','CTB_GRUPO_CENTRO','CD_GRUPO',CD_GRUPO_INT_W,'BKF')),0)
	into STRICT	cd_grupo_tasy_w
	;

	if (cd_grupo_tasy_w = 0) then

		ie_status_w	:= 'E';
		ds_erro_w	:= wheb_mensagem_pck.get_Texto(450341,'CD_GRUPO_INT_W='||CD_GRUPO_INT_W);/*Não foi cadastrada a conversão para o grupo do centro de custo #@CD_GRUPO_INT_W#@ que veio do sistema externo.*/
	else

		select	count(*)
		into STRICT	qt_registros_w
		from	ctb_grupo_centro
		where	cd_grupo = CD_GRUPO_TASY_W;

		if (qt_registros_w = 0) then

			ie_status_w	:= 'E';
			ds_erro_w	:= wheb_mensagem_pck.get_texto(450342,'CD_GRUPO_TASY_W='|| CD_GRUPO_TASY_W);
					/*Não existe no Tasy o código do grupo do centro de custo com código  #@CD_GRUPO_TASY_W#@.Verifique se o código que foi colocado na conversão está correto.*/

		end if;
	end if;
end if;



/*ESTABELECIMENTO*/

if (ie_status_w = 'OK') and (coalesce(cd_estabelecimento_int_w::text, '') = '') then

	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450096);/*Favor informar um estabelecimento.*/
end if;

if (ie_status_w = 'OK') and (cd_estabelecimento_int_w IS NOT NULL AND cd_estabelecimento_int_w::text <> '') then

	select	coalesce(somente_numero(bkf_obter_conv_interna('','ESTABELECIMENTO','CD_ESTABELECIMENTO',CD_ESTABELECIMENTO_INT_W,'BKF')),0)
	into STRICT	cd_estab_tasy_w
	;

	if (cd_estab_tasy_w = 0) then
		ie_status_w	:= 'E';
		ds_erro_w	:= wheb_mensagem_pck.get_Texto(450104,'CD_ESTABELECIMENTO_W='||CD_ESTABELECIMENTO_INT_W);/*Não foi cadastrada a conversão para o estabelecimento código #@CD_ESTABELECIMENTO_W#@ que veio do sistema externo.*/
	else

		select	count(*)
		into STRICT	qt_registros_w
		from	estabelecimento
		where	cd_estabelecimento = cd_estab_tasy_w
		and	ie_situacao = 'A';

		if (qt_registros_w = 0) then
			ie_status_w	:= 'E';
			ds_erro_w	:= wheb_mensagem_pck.get_texto(446447,'CD_ESTAB_TASY_W='|| cd_estab_tasy_w ||';CD_ESTABELECIMENTO_W='|| CD_ESTABELECIMENTO_INT_W);
					/*Não existe no Tasy o estabelecimento com código  #@CD_ESTAB_TASY_W#@.Verifique o cadastro de conversão para o código do estabelecimento #@CD_ESTABELECIMENTO_W#@ que veio do sistema externo.*/

		end if;
	end if;
end if;




/*IE_TIPO*/

if (ie_status_w = 'OK') and (coalesce(ie_tipo_int_w::text, '') = '') then

	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450332);/*Favor informar um tipo de centro custo. Campo obrigatório.*/
else
	if (ie_tipo_int_w not in ('A','T')) then

	ie_status_w	:= 'E';
	ds_erro_w	:= wheb_mensagem_pck.get_Texto(450333);/*Favor informar um tipo de centro custo válido (A para analítica e T para título).*/
	end if;
end if;



/*IE_TIPO_CUSTO*/

if (ie_status_w = 'OK') and (ie_tipo_custo_int_w IS NOT NULL AND ie_tipo_custo_int_w::text <> '') then

	if (ie_tipo_custo_int_w not in ('C','N','S','B','T')) then

		ie_status_w	:= 'E';
		ds_erro_w	:= wheb_mensagem_pck.get_Texto(450334);/*Favor informar um tipo de custo válido (C para comprador, N para convênio, S para fornecedor selecionado, B para nenhum e-mail padrão e T para todos os fornecedores da autorização.).*/
	end if;
end if;



/*IE_PERIODO_PROJ_RECEITA*/

if (ie_status_w = 'OK') and (ie_periodo_proj_receita_int_w IS NOT NULL AND ie_periodo_proj_receita_int_w::text <> '') then

	if (ie_periodo_proj_receita_int_w not in ('U','C')) then

		ie_status_w	:= 'E';
		ds_erro_w	:= wheb_mensagem_pck.get_Texto(450335);/*Favor informar um tipo de período de projeto válido (U para dias úteis e C para dias corridos).*/
	end if;
end if;




if (ie_status_w = 'OK') then

	select	count(*)
	into STRICT	qt_registros_w
	from	centro_custo
	where	cd_sistema_contabil = cd_sistema_contabil_int_w;

	if (qt_registros_w = 0) then

		select 	coalesce(max(cd_centro_custo),0) + 1
		into STRICT	cd_centro_custo_w
		from 	centro_custo;

		insert into centro_custo(
			cd_centro_custo,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_centro_custo,
			ie_situacao,
			cd_classificacao,
			cd_grupo,
			cd_estabelecimento,
			ie_tipo,
			ie_tipo_custo,
			ie_periodo_proj_receita,
			cd_sistema_contabil,
			ds_observacao)
		values (	cd_centro_custo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_centro_custo_int_w,
			ie_situacao_int_w,
			cd_classificacao_int_w,
			cd_grupo_int_w,
			cd_estab_tasy_w,
			ie_tipo_int_w,
			ie_tipo_custo_int_w,
			ie_periodo_proj_receita_int_w,
			cd_sistema_contabil_int_w,
			ds_observacao_int_w);
	else
		update	centro_custo
		set	ds_centro_custo = coalesce(ds_centro_custo_int_w,ds_centro_custo),
			ie_situacao = coalesce(ie_situacao_int_w,ie_situacao),
			cd_classificacao = coalesce(cd_classificacao_int_w,cd_classificacao),
			cd_grupo = coalesce(cd_grupo_int_w,cd_grupo),
			cd_estabelecimento = coalesce(cd_estab_tasy_w,cd_estabelecimento),
			ie_tipo = coalesce(ie_tipo_int_w,ie_tipo),
			ie_tipo_custo = coalesce(ie_tipo_custo_int_w,ie_tipo_custo),
			ie_periodo_proj_receita = coalesce(ie_periodo_proj_receita_int_w,ie_periodo_proj_receita),
			ds_observacao = coalesce(ds_observacao_int_w,ds_observacao)
		where	cd_sistema_contabil = cd_sistema_contabil_int_w;
	end if;
end if;


delete from 	w_int_centro_custo
where 		nr_sequencia = nr_seq_centro_custo_p;


commit;


ie_status_p		:= ie_status_w;
ds_erro_p		:= ds_erro_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_centro_custo ( nr_seq_centro_custo_p bigint, nm_usuario_p text, ie_status_p INOUT text, ds_erro_p INOUT text) FROM PUBLIC;
