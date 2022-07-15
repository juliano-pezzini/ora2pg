-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (nr_titulo double precision, vl_saldo double precision);
CREATE TYPE tGuia AS (nr_sequencia double precision, nr_titulo_item double precision, nr_conta double precision, cd_autoriz varchar(20), vl_pago double precision, vl_guia double precision, vl_saldo double precision);


CREATE OR REPLACE PROCEDURE consistir_retorno_convenio ( nr_seq_retorno_p bigint, nm_usuario_p text, ie_lote_recurso_p text, ie_commit_p text) AS $body$
DECLARE

type Vetor is table of campos index by integer;
type vGuia is table of tGuia index by integer;

nr_sequencia_w		bigint;
nr_conta_w		bigint;
cd_autoriz_w		varchar(20);
vl_pago_w		double precision;
vl_adequado_w		double precision;
nr_seq_protocolo_w	bigint;
nr_titulo_w		bigint;
qt_erros_w		integer;
qt_guia_sem_nf bigint;
qt_guia_sem_prot bigint;
ie_sem_saldo_w		varchar(2000)	:= '';
ie_consiste_solic_desc_w	varchar(10);
vl_param_302	varchar(10);
vl_param_298	varchar(10);
vl_titulo_w		double precision;
vl_saldo_w		double precision;
vl_soma_titulo_w		double precision;
vl_soma_retorno_w		double precision;
Vetor_Titulo_w		Vetor;
Vetor_Guia_w       vGuia;
nr_tit_vetor_w		bigint;
i			integer;
cguia   	integer;
ie_retorno_neg_w		varchar(1);
ie_tit_ret_senha_w		varchar(255);
qt_registro_w		bigint;
cd_convenio_w		bigint;
cd_estabelecimento_w	bigint;
vl_guia_w		double precision;
ds_historico_w		varchar(4000);
nr_prot_sem_nf bigint;
nr_interno_conta_erro_w	bigint;
cd_autorizacao_erro_w	varchar(255);
cd_autorizacao_senha_w	varchar(255);
qt_dias_venc_w		integer;
ie_tipo_data_ref_w		varchar(1);
nr_interno_conta_w		bigint;
cd_centro_custo_desc_w	integer;
nr_seq_motivo_desc_w	bigint;
ie_obrigar_glosa_w		varchar(1)	:= 'N';
qt_itens_glosados_w	bigint;
qt_itens_maior_w		bigint;
qt_guia_nc_w		bigint	:= 0;
qt_nota_credito_w		bigint	:= 0;
vl_saldo_final_w		double precision;
ie_varios_itens_glosados_w	varchar(255);
cont_item_w		bigint;
nr_seq_propaci_glosa_w	bigint;
nr_seq_partic_glosa_w	bigint;
vl_amenor_w			double precision;
nr_seq_cobranca_w	bigint;
nr_titulo_item_w	bigint;
ie_trib_titulo_retorno_w	varchar(1);
vl_tributo_guia_w	titulo_receber_trib.vl_tributo%type;
vl_glosa_hist_guia_w	double precision;
count_guia_ret_w	bigint;
vl_conpagui_w		double precision;
vl_pago_aux_w		double precision;
vl_tributo_guia_total_w	titulo_receber_trib.vl_tributo%type;
vl_tributo_titulo_w	titulo_receber_trib.vl_tributo%type;
ie_show_all_issues_ir_w parametro_faturamento.ie_show_all_issues_ir%type;
nr_titulo_rec_w   titulo_receber_nc.nr_titulo_rec%type;
nr_nota_credito_w titulo_receber_nc.nr_seq_nota_credito%type;
cd_item_w        conv_retorno_validacao.cd_item%type;
c_incons integer;
vl_pago_trib_w      double precision;
vl_diferenca_w  titulo_receber_trib.vl_tributo%type;

Retorno_Item CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_interno_conta,
	somente_numero(a.cd_autorizacao),
	coalesce(a.vl_adequado,0) * -1,
	a.vl_pago + a.vl_glosado + coalesce(a.vl_desconto,0) vl_pago,
	b.nr_seq_protocolo,
	a.vl_guia,
	a.cd_autorizacao cd_autorizacao_senha,
	a.vl_amenor,
	a.nr_titulo,
	a.vl_pago + coalesce(a.vl_adicional,0) + coalesce(a.vl_desconto,0) vl_pago_trib
from	conta_paciente b,
	convenio_retorno_item a
where	a.nr_interno_conta = b.nr_interno_conta
and	a.nr_seq_retorno = nr_seq_retorno_p
order	by a.nr_titulo,
	b.nr_seq_protocolo,
	vl_pago,
	a.nr_interno_conta,
	somente_numero(a.cd_autorizacao) desc;

Titulo CURSOR FOR
SELECT	nr_titulo,
	vl_titulo, 
	vl_saldo_titulo
from 	(SELECT	a.dt_pagamento_previsto,
		a.nr_titulo,
		a.vl_titulo,
		a.vl_saldo_titulo
	from	titulo_receber a
	where	ie_situacao	<> '3' 
	and (a.nr_documento IS NOT NULL AND a.nr_documento::text <> '') 
	and	a.nr_documento	<> nr_conta_w
	and	a.nr_interno_conta	= nr_conta_w
	and	a.nr_documento	= cd_autoriz_w	/* Francisco - 29/04/2009 - Tirei o comentario ,OS 128238 */
	and (coalesce(nr_seq_cobranca_w::text, '') = '' or coalesce(nr_titulo_item_w::text, '') = '')
	
union

	select	a.dt_pagamento_previsto,
		a.nr_titulo,
		a.vl_titulo,
		a.vl_saldo_titulo
	from	conta_paciente b,
		titulo_receber a
	where	a.ie_situacao				<> '3'
	and	a.nr_interno_conta				= b.nr_interno_conta
	and (a.nr_documento IS NOT NULL AND a.nr_documento::text <> '') 
	and	a.nr_documento				<> nr_conta_w
	and	a.nr_interno_conta				= nr_conta_w
	and	a.nr_documento				<> cd_autoriz_w
	and	obter_senha_atendimento(b.nr_atendimento)	= cd_autorizacao_senha_w	/* Edgar 06/05/2009 OS 140226, localizar o titulo pela senha do atendimento devido a despadronizacao do Bradesco */
	and	ie_tit_ret_senha_w				= 'S'
	and (coalesce(nr_seq_cobranca_w::text, '') = '' or coalesce(nr_titulo_item_w::text, '') = '')
	
union

	select	dt_pagamento_previsto,
		nr_titulo,
		vl_titulo,
		vl_saldo_titulo
	from	titulo_receber
	where	ie_situacao <> '3'  
	and	(nr_conta_w IS NOT NULL AND nr_conta_w::text <> '')
	and	((nr_documento = nr_conta_w) or (coalesce(nr_documento::text, '') = ''))
	and	nr_interno_conta = nr_conta_w
	and (coalesce(nr_seq_cobranca_w::text, '') = '' or coalesce(nr_titulo_item_w::text, '') = '')
	
union

	select	dt_pagamento_previsto,
		nr_titulo,
		vl_titulo,
		vl_saldo_titulo
	from	titulo_receber
	where	ie_situacao	<> '3' 
	and	nr_seq_protocolo	= nr_seq_protocolo_w
 	and	coalesce(nr_interno_conta::text, '') = ''
	and (coalesce(nr_seq_cobranca_w::text, '') = '' or coalesce(nr_titulo_item_w::text, '') = '')
	
union

	select	a.dt_pagamento_previsto,
		a.nr_titulo,
		a.vl_titulo,
		a.vl_saldo_titulo
	from	titulo_receber a,
		protocolo_convenio b
	where	a.nr_seq_lote_prot	= b.nr_seq_lote_protocolo
	and	a.ie_situacao		<> '3' 
	and	b.nr_seq_protocolo	= nr_seq_protocolo_w
 	and	coalesce(a.nr_interno_conta::text, '') = ''
	and	coalesce(a.nr_seq_protocolo::text, '') = ''
	and (coalesce(nr_seq_cobranca_w::text, '') = '' or coalesce(nr_titulo_item_w::text, '') = '')
	
union

	select	dt_pagamento_previsto,
		a.nr_titulo,
		a.vl_titulo,
		a.vl_saldo_titulo
	from	titulo_receber a
	where	ie_tit_ret_senha_w	<> 'S'
	and	a.ie_situacao	<> '3'
	and	a.nr_interno_conta	= nr_conta_w
	and	not exists (select	1
		from	titulo_receber x
		where	x.ie_situacao	<> '3' 
		and (x.nr_documento IS NOT NULL AND x.nr_documento::text <> '') 
		and	x.nr_documento	<> nr_conta_w
		and	x.nr_interno_conta	= nr_conta_w
		and	x.nr_documento	= cd_autoriz_w) /* ahoffelder - OS 259784 - 27/10/2010 */
	and (coalesce(nr_seq_cobranca_w::text, '') = '' or coalesce(nr_titulo_item_w::text, '') = '')
	
union all

	/* ahoffelder - OS 433342 - 02/05/2012 - se o retorno foi gerado pela cobranca escritural, o titulo ja foi vinculado */

	select	a.dt_pagamento_previsto,
		a.nr_titulo,
		a.vl_titulo,
		a.vl_saldo_titulo
	from	titulo_receber a
	where	a.nr_titulo		= nr_titulo_item_w
	and (nr_seq_cobranca_w IS NOT NULL AND nr_seq_cobranca_w::text <> '' AND nr_titulo_item_w IS NOT NULL AND nr_titulo_item_w::text <> '')) alias32
order by	dt_pagamento_previsto,
	nr_titulo;

ItensGlosados CURSOR FOR
SELECT	count(*),
    coalesce(b.cd_procedimento, b.cd_material) cd_item,
	b.nr_seq_propaci,
	b.nr_seq_partic
FROM convenio_retorno_glosa b
LEFT OUTER JOIN motivo_glosa a ON (b.cd_motivo_glosa = a.cd_motivo_glosa)
WHERE (b.nr_seq_propaci IS NOT NULL AND b.nr_seq_propaci::text <> '')  and (coalesce(b.ie_acao_glosa,a.ie_acao_glosa) IS NOT NULL AND (coalesce(b.ie_acao_glosa,a.ie_acao_glosa))::text <> '') and b.nr_seq_ret_item		= nr_sequencia_w group by	b.nr_seq_ret_item,
    coalesce(b.cd_procedimento, b.cd_material),
	b.nr_seq_propaci,
	b.nr_seq_partic,
	coalesce(b.ie_acao_glosa,a.ie_acao_glosa);

c01 CURSOR FOR
SELECT	nr_interno_conta,
	cd_autorizacao,
    nr_sequencia
from	convenio_retorno_item
where	nr_seq_retorno	= nr_seq_retorno_p
and	coalesce(nr_titulo::text, '') = '';

c02 CURSOR FOR
SELECT	nr_titulo,
	sum(VL_TRIBUTO_GUIA)
from	convenio_retorno_item a
where	a.nr_seq_retorno	= nr_seq_retorno_p
and	(nr_titulo IS NOT NULL AND nr_titulo::text <> '')
group by nr_titulo
having sum(VL_TRIBUTO_GUIA) > 0;

c03 CURSOR FOR
SELECT a.nr_interno_conta,
	a.cd_autorizacao,
	obter_protocolo_conpaci(a.nr_interno_conta),
    a.nr_sequencia
from convenio_retorno_item a
where a.nr_seq_retorno = nr_seq_retorno_p
and coalesce(obter_nf_conta_ret(a.nr_interno_conta, 1)::text, '') = '';

ItensPendGlosa CURSOR FOR
SELECT	a.nr_sequencia,
        a.nr_interno_conta
from	convenio_retorno_item a
where	a.nr_seq_retorno		= nr_seq_retorno_p
and (coalesce(a.vl_glosado,0)	<> 0 or	
	coalesce(a.vl_amenor,0) 	<> 0 or
	coalesce(a.vl_adicional,0)	<> 0)
and	a.vl_pago		>= 0
and	a.vl_pago		< a.vl_guia
and	not exists (SELECT	1
		from	convenio_retorno_glosa b
		where	b.nr_seq_ret_item	= a.nr_sequencia);

ItensValorMaior CURSOR FOR
SELECT	a.nr_sequencia,
        a.nr_interno_conta
from	convenio_retorno_item a
where	a.nr_seq_retorno		= nr_seq_retorno_p
and (a.vl_adicional		> a.vl_guia
	or a.vl_pago		> a.vl_guia);

NotaPendRateio CURSOR FOR      
SELECT	nr_titulo_rec,nr_seq_nota_credito
from	titulo_receber_nc a
where	a.nr_titulo_rec	in (SELECT	(obter_titulo_conta_guia(x.nr_interno_conta,x.cd_autorizacao,x.nr_seq_retorno,null))::numeric 
	from	convenio_retorno_item x
	where	x.nr_seq_retorno	= nr_seq_retorno_p)
and	coalesce(a.nr_seq_liq::text, '') = '';

procedure consistir_retorno_convenio_msg(nr_msg_p bigint, ds_msg_p text := null) is
;
BEGIN
    if (ie_show_all_issues_ir_w = 'N') then
        if coalesce(ds_msg_p::text, '') = '' then
            CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_msg_p);
        else
            CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_msg_p,ds_msg_p);
        end if;
    else

        CALL insere_conv_retorno_validacao(nr_seq_retorno_p,nr_interno_conta_w,cd_autoriz_w,cd_item_w, wheb_mensagem_pck.get_texto(nr_msg_p,ds_msg_p),nr_titulo_rec_w,nr_nota_credito_w,0,0,nr_sequencia_w,nm_usuario_p);
        if (Vetor_Guia_w.count > 0) then
            i := 1;
			for i in 1..Vetor_Guia_w.count loop
                CALL insere_conv_retorno_validacao(nr_seq_retorno_p,Vetor_Guia_w[i].nr_conta,Vetor_Guia_w[i].cd_autoriz,null,'conta '||Vetor_Guia_w[i].nr_conta||' valor '||Vetor_Guia_w[i].vl_pago||' saldo do titulo '||Vetor_Guia_w[i].vl_saldo,Vetor_Guia_w[i].nr_titulo_item,null,Vetor_Guia_w[i].vl_pago,Vetor_Guia_w[i].vl_saldo,Vetor_Guia_w[i].nr_sequencia,nm_usuario_p);
            end loop;
        end if;
    end if;

 end;

BEGIN

select	cd_convenio,
	cd_estabelecimento,
	nr_seq_cobranca
into STRICT	cd_convenio_w,
	cd_estabelecimento_w,
	nr_seq_cobranca_w
from	convenio_retorno
where	nr_sequencia	= nr_seq_retorno_p;

ie_consiste_solic_desc_w	:= Obter_Valor_Param_Usuario(27, 51, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w);
ie_varios_itens_glosados_w	:= Obter_Valor_Param_Usuario(27, 190, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w);
vl_param_298 := Obter_Valor_Param_Usuario(27, 298, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w);

select coalesce(ie_show_all_issues_ir,'N')
into STRICT ie_show_all_issues_ir_w
from parametro_faturamento
where 	cd_estabelecimento = cd_estabelecimento_w;
--ie_show_all_issues_ir_w := 'N';
if ie_show_all_issues_ir_w = 'S' then
     delete from conv_retorno_validacao where nr_seq_retorno = nr_seq_retorno_p;
end if;


if (coalesce(ie_consiste_solic_desc_w,'N') = 'S') then
	select	max(nr_interno_conta)
	into STRICT	nr_interno_conta_w
	from	convenio_retorno_item a
	where	nr_seq_retorno		= nr_seq_retorno_p
	and	((coalesce(a.vl_desconto,0)	<> 0) or (coalesce(a.vl_perdas,0)	<> 0))
	and	not exists (	SELECT	1
				from	convenio_ret_item_desc x
				where	x.nr_seq_ret_item	= a.nr_sequencia);


	if (coalesce(nr_interno_conta_w, 0)	> 0) then
		/* Existem guias com valor de desconto/perdas e sem solicitante informado para a conta nr_interno_conta_w */

        consistir_retorno_convenio_msg(187119,'NR_INTERNO_CONTA_W='||nr_interno_conta_w);
	end if;
elsif (coalesce(ie_consiste_solic_desc_w,'N') = 'R') then
	select	max(nr_interno_conta)
	into STRICT	nr_interno_conta_w
	from	convenio_retorno_item a
	where	nr_seq_retorno		= nr_seq_retorno_p
	and	((coalesce(a.vl_desconto,0)	<> 0) or (coalesce(a.vl_perdas,0)	<> 0) or (coalesce(a.vl_glosado,0)	<> 0))
	and	not exists (	SELECT	1
				from	convenio_ret_item_desc x
				where	x.nr_seq_ret_item	= a.nr_sequencia);


	if (coalesce(nr_interno_conta_w, 0)	> 0) then
		/* Existem guias com valor de desconto/perdas/glosa e sem solicitante informado para a conta #@NR_INTERNO_CONTA_W#@ */

        consistir_retorno_convenio_msg(239849,'NR_INTERNO_CONTA_W='||nr_interno_conta_w);
	end if;

end if;

if (coalesce(ie_consiste_solic_desc_w,'N')	= 'S') then
	select	max(cd_centro_custo_desc),
		max(nr_seq_motivo_Desc),
		max(nr_interno_conta)
	into STRICT	cd_centro_custo_desc_w,
		nr_seq_motivo_Desc_w,
		nr_interno_conta_w
	from	convenio_retorno_item a
	where	nr_seq_retorno		= nr_seq_retorno_p
	and	((coalesce(a.vl_desconto,0)	<> 0) or (coalesce(a.vl_perdas,0)	<> 0));

	if (coalesce(nr_interno_conta_w, 0)		> 0) and
		((coalesce(cd_centro_custo_desc_w, 0)	= 0) or (coalesce(nr_seq_motivo_Desc_w,0) 		= 0)) then
		/* Existem guias com valor de desconto/perdas e sem Centro de custo/Motivo desconto informado para a conta nr_interno_conta_w */

        consistir_retorno_convenio_msg(187121,'NR_INTERNO_CONTA_W='||nr_interno_conta_w);
	end if;
elsif (coalesce(ie_consiste_solic_desc_w,'N')	= 'R') then
	select	max(nr_interno_conta)
	into STRICT	nr_interno_conta_w
	from	convenio_retorno_item a
	where	nr_seq_retorno		= nr_seq_retorno_p
	and	((coalesce(a.vl_desconto,0)	<> 0) or (coalesce(a.vl_perdas,0)	<> 0) or (coalesce(a.vl_glosado,0)	<> 0))
	and (coalesce(cd_centro_custo_desc::text, '') = '' or coalesce(nr_seq_motivo_Desc::text, '') = '');

	if (coalesce(nr_interno_conta_w,0) > 0)  then
		/* Existem guias com valor de desconto/perdas/glosa e sem Centro de custo/Motivo desconto informado para a conta #@NR_INTERNO_CONTA_W#@ */

        consistir_retorno_convenio_msg(239850,'NR_INTERNO_CONTA_W='||nr_interno_conta_w);
	end if;

end if;

select	coalesce(max(ie_tit_ret_senha),'N')
into STRICT	ie_tit_ret_senha_w
from	convenio_estabelecimento
where	cd_convenio		= cd_convenio_w
and	cd_estabelecimento	= cd_estabelecimento_w;

select	count(*)
into STRICT	qt_erros_w
from	conta_paciente b,
	convenio_retorno_item a
where	a.nr_seq_retorno = nr_seq_retorno_p
and	a.nr_interno_conta = b.nr_interno_conta
and	(b.ie_cancelamento IS NOT NULL AND b.ie_cancelamento::text <> '');

if (qt_erros_w <> 0) then
	/* Existem itens com conta cancelada! */

    consistir_retorno_convenio_msg(187123);
end if;

select sum(vl_pago + vl_glosado + coalesce(vl_desconto,0))
into STRICT vl_pago_w
from convenio_retorno_item
where nr_seq_retorno = nr_seq_retorno_p;

select 	coalesce(max(ie_retorno_neg),'N')
into STRICT	ie_retorno_neg_w
from parametro_faturamento;

if (vl_pago_w < 0 AND ie_retorno_neg_w = 'N') then
	/* Retorno com valor negativo, nao pode ser baixado! */

    consistir_retorno_convenio_msg(187124);
end if;

/* obrigar a adicionar itens glosados - ahoffelder - 23/09/2009 - 167708 */

select	coalesce(max(a.ie_obrigar_item_glosa),'N'),
	coalesce(max(a.ie_trib_titulo_retorno),'N')
into STRICT	ie_obrigar_glosa_w,
	ie_trib_titulo_retorno_w
from	convenio_estabelecimento a,
	convenio_retorno b
where	b.nr_sequencia		= nr_seq_retorno_p
and	b.cd_estabelecimento	= a.cd_estabelecimento
and	b.cd_convenio		= a.cd_convenio;

if (ie_obrigar_glosa_w = 'S') then
    open ItensPendGlosa;
    loop
    fetch ItensPendGlosa into
            nr_sequencia_w,
            nr_interno_conta_w;
    EXIT WHEN NOT FOUND; /* apply on ItensPendGlosa */
        consistir_retorno_convenio_msg(187125,'NR_INTERNO_CONTA_W='||nr_interno_conta_w);
    end loop;
    close ItensPendGlosa;
    nr_sequencia_w := null;
end if;


if (Obter_Valor_Param_Usuario(27, 105, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w) = 'N') then
    open ItensValorMaior;
    loop
    fetch ItensValorMaior into
            nr_sequencia_w,
            nr_interno_conta_w;
    EXIT WHEN NOT FOUND; /* apply on ItensValorMaior */
        consistir_retorno_convenio_msg(187126);
    end loop;
    close ItensValorMaior;
    nr_sequencia_w := null;
end if;

select	count(*)
into STRICT	qt_guia_nc_w
from	convenio_retorno_item a
where	a.vl_nota_credito	> 0
and	a.nr_seq_retorno	= nr_Seq_retorno_p;

select	count(*)
into STRICT	qt_nota_credito_w
from	titulo_receber_nc a
where	a.nr_titulo_rec	in (SELECT	(obter_titulo_conta_guia(x.nr_interno_conta,x.cd_autorizacao,x.nr_seq_retorno,null))::numeric
	from	convenio_retorno_item x
	where	x.nr_seq_retorno	= nr_seq_retorno_p)
and	coalesce(a.nr_seq_liq::text, '') = '';

if (coalesce(qt_guia_nc_w,0) = 0) then
    open NotaPendRateio;
    loop
    fetch NotaPendRateio into
            nr_titulo_rec_w,
            nr_nota_credito_w;
    EXIT WHEN NOT FOUND; /* apply on NotaPendRateio */
        consistir_retorno_convenio_msg(187127);
    end loop;
    close NotaPendRateio;
end if;

ie_sem_saldo_w := '';
open Retorno_Item;
loop
fetch Retorno_Item into
	nr_sequencia_w,
	nr_conta_w,
	cd_autoriz_w,
	vl_adequado_w,
	vl_pago_w,
	nr_seq_protocolo_w,
	vl_guia_w,
	cd_autorizacao_senha_w,
	vl_amenor_w,
	nr_titulo_item_w,
	vl_pago_trib_w;
EXIT WHEN NOT FOUND; /* apply on Retorno_Item */
    nr_interno_conta_w := nr_conta_w;
	if (coalesce(ie_varios_itens_glosados_w, 'S') = 'N') then

		open ItensGlosados;
		loop
		fetch ItensGlosados into
			cont_item_w,
            cd_item_w,
			nr_seq_propaci_glosa_w,
			nr_seq_partic_glosa_w;
		EXIT WHEN NOT FOUND; /* apply on ItensGlosados */

			if (cont_item_w > 1) then
				/* Existem lancmentos de item glosa para o mesmo proc/participante, com a mesma acao de glosa. Param [190]
				Guia: nr_sequencia_w
				Proc: nr_seq_propaci_glosa_w
				Partic: nr_seq_partic_glosa_w */
                consistir_retorno_convenio_msg(187131,
							'NR_SEQUENCIA_W='||nr_sequencia_w||';'||
							'NR_SEQ_PROPACI_GLOSA_W='||nr_seq_propaci_glosa_w||';'||
							'NR_SEQ_PARTIC_GLOSA_W='||nr_seq_partic_glosa_w);
			end if;

		end loop;
		close ItensGlosados;

	end if;

    
    
    cguia := Vetor_Guia_w.count + 1;
    Vetor_Guia_w[cguia].nr_sequencia  := nr_sequencia_w;
    Vetor_Guia_w[cguia].nr_conta := nr_conta_w;
    Vetor_Guia_w[cguia].cd_autoriz := cd_autoriz_w;
    Vetor_Guia_w[cguia].nr_titulo_item  := nr_titulo_item_w;
    Vetor_Guia_w[cguia].vl_guia  := vl_guia_w;
    Vetor_Guia_w[cguia].vl_pago  := vl_pago_w;

    

	if (coalesce(nr_seq_cobranca_w::text, '') = '') then

		/* ahoffelder - OS 340705 - 24/08/2011 - tirei esse update de antes do cursor, e coloquei dentro do cursor */

		update	convenio_retorno_item
		set	nr_titulo	 = NULL
		where	nr_sequencia	= nr_sequencia_w;	

	end if;

	/* Francisco - OS 138764 - 24/04/2009 */

	if (ie_lote_recurso_p = 'S') then
		select  count(*)
		into STRICT	qt_registro_w
		from    lote_audit_recurso a
		where   exists (SELECT  1
				from     conta_paciente_retorno y,
					conta_paciente_ret_hist x
		where    x.nr_seq_conpaci_ret = y.nr_sequencia
		and      x.nr_seq_lote_recurso = a.nr_sequencia
		and      y.nr_interno_conta    = nr_conta_w
		and      y.cd_autorizacao      = cd_autoriz_w);

		if (qt_registro_w > 0) then
			/* A conta nr_conta_w, guia cd_autoriz_w ja esta em lote de recurso, verifique. */

            consistir_retorno_convenio_msg(187142,
							'NR_CONTA_W='||nr_conta_w||';'||
							'CD_AUTORIZ_W='||cd_autoriz_w);
		end if;
	end if;

	if (vl_guia_w IS NOT NULL AND vl_guia_w::text <> '') then
		if (vl_guia_w - vl_pago_w < 0) then
			/* O saldo da conta/guia nr_conta_w / cd_autoriz_w nao pode ser negativo.
			Favor verificar. */
			consistir_retorno_convenio_msg(187143,
							'NR_CONTA_W='||nr_conta_w||';'||
							'CD_AUTORIZ_W='||cd_autoriz_w);
		end if;
	end if;

	nr_titulo_w		:= null;
	vl_saldo_final_w	:= coalesce(vl_pago_w,0) + coalesce(vl_amenor_w,0);

	open Titulo;
	loop
	fetch	Titulo into
		nr_titulo_w,
		vl_titulo_w,
		vl_saldo_w;
	EXIT WHEN NOT FOUND; /* apply on Titulo */

		if (vl_titulo_w	>= vl_adequado_w) then
			vl_saldo_w	:= vl_saldo_w + vl_adequado_w;
		else
			vl_saldo_w	:= vl_titulo_w;
			vl_adequado_w	:= vl_adequado_w - vl_titulo_w;
		end if;

		nr_tit_vetor_w := 0;
		i := 1;

		if (Vetor_Titulo_w.count > 0) then
			for i in 1..Vetor_Titulo_w.count loop
				if (Vetor_Titulo_w[i].nr_titulo = nr_titulo_w) then
					vl_saldo_w := Vetor_Titulo_w[i].vl_saldo;
					nr_tit_vetor_w := Vetor_Titulo_w[i].nr_titulo;
					exit;
				end if;
			end loop;
		end if;

		if (nr_tit_vetor_w = 0) then
			i := Vetor_Titulo_w.count + 1;
			Vetor_Titulo_w[i].nr_titulo := nr_titulo_w;
			Vetor_Titulo_w[i].vl_saldo  := vl_saldo_w;
		end if;

		if (coalesce(ie_trib_titulo_retorno_w,'N') = 'S') then --Ratear com base no valor pago
            if (coalesce(vl_param_302, 'N') = 'S') then --Somente se primeiro retorno da guia.
                select	count(*)
                into STRICT	count_guia_ret_w
                from	convenio_retorno_item a,
                    convenio_retorno b
                where	a.nr_seq_retorno	= b.nr_sequencia
                and	a.nr_interno_conta	= nr_conta_w
                and	a.cd_autorizacao	= cd_autorizacao_senha_w
                and	coalesce(vl_pago,0) + coalesce(vl_glosado,0) + coalesce(vl_desconto,0) + coalesce(vl_nota_credito,0) <> 0;

                if (count_guia_ret_w <= 1) then --So faz o rateior na primeira vez da guia no retorno
                    vl_tributo_guia_w := ratear_tributo_tit_guia(nr_titulo_w, vl_pago_trib_w, vl_tributo_guia_w);
                    vl_pago_aux_w	:= vl_pago_w;

                    --if	(vl_tributo_guia_w > 0) then
                        vl_pago_w	:= vl_pago_w - coalesce(vl_tributo_guia_w,0);
                    --end if;
                end if;
            else

                vl_tributo_guia_w := ratear_tributo_tit_guia(nr_titulo_w, vl_pago_trib_w, vl_tributo_guia_w);
                vl_pago_aux_w	:= vl_pago_w;

                --if	(vl_tributo_guia_w > 0) then
                	vl_pago_w	:= vl_pago_w - coalesce(vl_tributo_guia_w,0);
                --end if;
            end if;
		elsif (coalesce(ie_trib_titulo_retorno_w,'N') = 'G') then --Ratear com base no valor da guia.
            if (coalesce(vl_param_302, 'N') = 'S') then --Somente se primeiro retorno da guia.
                
                select	count(*)
                into STRICT	count_guia_ret_w
                from	convenio_retorno_item a,
                    convenio_retorno b
                where	a.nr_seq_retorno	= b.nr_sequencia
                and	a.nr_interno_conta	= nr_conta_w
                and	a.cd_autorizacao	= cd_autorizacao_senha_w
                and	coalesce(vl_pago,0) + coalesce(vl_glosado,0) + coalesce(vl_desconto,0) + coalesce(vl_nota_credito,0) <> 0;

                if (count_guia_ret_w <= 1) then --So faz o rateior na primeira vez da guia no retorno
                    select	coalesce(max(vl_guia),0)
                    into STRICT	vl_conpagui_w
                    from	conta_paciente_guia
                    where	nr_interno_conta	= nr_conta_w
                    and	cd_autorizacao		= cd_autorizacao_senha_w;

                    vl_tributo_guia_w := ratear_tributo_tit_guia(nr_titulo_w, vl_conpagui_w, vl_tributo_guia_w);

                    if (vl_tributo_guia_w > 0) then
                        vl_pago_w	:= vl_pago_w - vl_tributo_guia_w;
                    end if;
				end if;
            else

                select	coalesce(max(vl_guia),0)
                into STRICT	vl_conpagui_w
                from	conta_paciente_guia
                where	nr_interno_conta	= nr_conta_w
                and	cd_autorizacao		= cd_autorizacao_senha_w;

                vl_tributo_guia_w := ratear_tributo_tit_guia(nr_titulo_w, vl_conpagui_w, vl_tributo_guia_w);

                if (vl_tributo_guia_w > 0) then
                    vl_pago_w	:= vl_pago_w - vl_tributo_guia_w;
                end if;
            end if;
        end if;

        Vetor_Guia_w[cguia].vl_saldo  := vl_saldo_w;
		if (vl_saldo_w > 0) then
			vl_saldo_final_w	:= vl_saldo_final_w - vl_saldo_w;	/* ahoffelder - OS 317382 - 13/05/2011 */
			vl_saldo_w := vl_saldo_w - vl_pago_w;
			Vetor_Titulo_w[i].vl_saldo  := vl_saldo_w;


			/*Ajuste no saldo devido arredondamento quando definido para ratear o tributo*/

			if (coalesce(ie_trib_titulo_retorno_w,'N') in ('S','G')) and (vl_saldo_w < -0.00) and (vl_saldo_w > -1.00) then
				vl_saldo_w	:= 0;
				vl_tributo_guia_w	:= vl_tributo_guia_w + vl_saldo_w;
			end if;

			if (vl_saldo_w <= 0) then
				vl_pago_w	:= vl_pago_w + vl_saldo_w;
				if (vl_saldo_w = 0) then
					vl_pago_w  := 0;
					exit;
				end if;
			else
				vl_pago_w  := 0;
				exit;
			end if;			


			--dbms_output.put_line(vl_saldo_w || 'X' || vl_pago_w);			
		end if;		

	end loop;
	close Titulo;

	update	convenio_retorno_item
  --721237 = Titulo obter_desc_expressao(721237)
	set	ds_observacao	=  substr(substr(replace(ds_observacao, obter_desc_expressao(721237)||': ' || nr_titulo_w || chr(13) || chr(10), ''),1,3900) ||
				   obter_desc_expressao(721237)||': '|| nr_titulo_w || chr(13) || chr(10),1,3999)
	where	nr_seq_retorno	= nr_seq_retorno_p
	and	nr_sequencia	= nr_sequencia_w;


	if (vl_pago_w > 0) and (coalesce(length(ie_sem_saldo_w),0) <= 1985) then
		ie_sem_saldo_w	:= ie_sem_saldo_w || nr_conta_w || ', ';

	/* ahoffelder - OS 367533 - 19/12/2011 - alterei para vl_pago_w <= 0 para o caso de estorno */

	elsif (vl_pago_w <= 0) or (vl_saldo_final_w = 0) then
		update	convenio_retorno_item
		set	nr_titulo	= nr_titulo_w,
      --721237 = Titulo 
			ds_observacao	= substr(replace(ds_observacao, obter_desc_expressao(721237)||': ' || nr_titulo_w || chr(13) || chr(10), ''), 1,3999),
			vl_tributo_guia	= vl_tributo_guia_w
		where	nr_seq_retorno	= nr_seq_retorno_p
		and	nr_sequencia	= nr_sequencia_w;

	end if;
end loop;

close Retorno_Item;

if (ie_commit_p = 'S') then
	commit;
end if;

if (coalesce(length(ie_sem_saldo_w),0) > 0) then
	insert into convenio_retorno_hist(NR_SEQUENCIA,
		DT_ATUALIZACAO,
		NM_USUARIO,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO_NREC,
		NR_SEQ_RETORNO,
		DT_HISTORICO,
		DS_HISTORICO)
	SELECT	nextval('convenio_retorno_hist_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_retorno_p,
		clock_timestamp(),
		substr( WHEB_MENSAGEM_PCK.get_texto(304918) || ie_sem_saldo_w, 1,3999)
	;
	commit;
	/* Existem contas sem saldo: ie_sem_saldo_w */

	consistir_retorno_convenio_msg(187145,
							'IE_SEM_SALDO_W='||ie_sem_saldo_w);
end if;
Vetor_Guia_w.delete;
select	count(*)
into STRICT	qt_erros_w
from	convenio_retorno_item
where	nr_seq_retorno	= nr_seq_retorno_p
and	coalesce(nr_titulo::text, '') = '';

if (qt_erros_w <> 0) then
	ds_historico_w	:= WHEB_MENSAGEM_PCK.get_texto(304923, 'QT_ERROS_W=' || qt_erros_w);
	open c01;
	loop
	fetch c01 into
		nr_interno_conta_erro_w,
		cd_autorizacao_erro_w,
        nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		ds_historico_w	:= substr(ds_historico_w || chr(13) || 		
					WHEB_MENSAGEM_PCK.get_texto(304924) || nr_interno_conta_erro_w || ' / ' || cd_autorizacao_erro_w, 1, 3999);
	end loop;
	close c01;
	insert into convenio_retorno_hist(NR_SEQUENCIA,
		DT_ATUALIZACAO,
		NM_USUARIO,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO_NREC,
		NR_SEQ_RETORNO,
		DT_HISTORICO,
		DS_HISTORICO)
	SELECT	nextval('convenio_retorno_hist_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_retorno_p,
		clock_timestamp(),
		substr(ds_historico_w, 1,3999)
	;

	if (ie_commit_p	= 'S') then
		commit;
	end if;	

	/* Existem itens que nao possuem titulo e/ou saldo! */

	consistir_retorno_convenio_msg(187146);
end if;

if vl_param_298 = 'S' then

	select count(*)
	into STRICT qt_guia_sem_nf
	from convenio_retorno_item a
	where a.nr_seq_retorno = nr_seq_retorno_p
	and coalesce(obter_nf_conta_ret(a.nr_interno_conta, 1)::text, '') = '';	

	if qt_guia_sem_nf <> 0 then
			ds_historico_w := '';
			open c03;
			loop
			fetch c03 into
				nr_interno_conta_erro_w,
				cd_autorizacao_erro_w,
				nr_prot_sem_nf,
                nr_sequencia_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */

				ds_historico_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(1073539) || nr_prot_sem_nf || ' - ' || WHEB_MENSAGEM_PCK.get_texto(304924) || nr_interno_conta_erro_w || '/' || cd_autorizacao_erro_w, 1, 3999);

				insert into convenio_retorno_hist(NR_SEQUENCIA,
				DT_ATUALIZACAO,
				NM_USUARIO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				NR_SEQ_RETORNO,
				DT_HISTORICO,
				DS_HISTORICO)
				SELECT	nextval('convenio_retorno_hist_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_retorno_p,
					clock_timestamp(),
					substr(ds_historico_w, 1,3999)
				;

				if (ie_commit_p	= 'S') then
					commit;
				end if;	

			end loop;
			close c03;							

			consistir_retorno_convenio_msg(1073535);
	end if;
end if;



select sum(coalesce(vl_pago,0) + coalesce(vl_glosado,0) + coalesce(vl_desconto,0) - coalesce(vl_tributo_guia,0))
into STRICT vl_soma_retorno_w
from convenio_retorno_item
where nr_seq_retorno = nr_seq_retorno_p;

select obter_saldo_retorno(nr_seq_retorno_p,1)
into STRICT vl_soma_titulo_w
;

if (vl_soma_retorno_w > vl_soma_titulo_w) then
	/* Valor do retorno supera o valor dos titulos!
	vl_soma_retorno_w > vl_soma_titulo_w */
	consistir_retorno_convenio_msg(187148,
							'VL_SOMA_RETORNO_W='||vl_soma_retorno_w||';'||
							'VL_SOMA_TITULO_W='||vl_soma_titulo_w);
end if;

if (ie_show_all_issues_ir_w = 'S') then
    select count(*) into STRICT c_incons from conv_retorno_validacao where nr_seq_retorno = nr_seq_retorno_p and ie_tipo_mensagem = 'I';
end if;

if((ie_show_all_issues_ir_w = 'N') or (ie_show_all_issues_ir_w = 'S' and c_incons = 0)) then

    update convenio_retorno
    set	ie_status_retorno	= 'C',
        dt_atualizacao	= clock_timestamp(),
        dt_consistencia	= clock_timestamp(),
        nm_usuario		= nm_usuario_p
    where nr_sequencia = nr_seq_retorno_p;

    select	max(qt_dias_venc),
        max(ie_tipo_data_ref)
    into STRICT	qt_dias_venc_w,
        ie_tipo_data_ref_w
    from	convenio_regra_venc_ret
    where	cd_convenio		= cd_convenio_w
    and	cd_estabelecimento	= cd_estabelecimento_w;

    if (qt_dias_venc_w IS NOT NULL AND qt_dias_venc_w::text <> '') and (ie_tipo_data_ref_w = 'C') then
        delete from convenio_retorno_venc
        where	nr_seq_retorno	= nr_seq_retorno_p;

        insert	into	convenio_retorno_venc(nr_sequencia,
            nm_usuario,
            dt_atualizacao,
            nm_usuario_nrec,
            dt_atualizacao_nrec,
            nr_seq_retorno,
            dt_vencimento)
        values (nextval('convenio_retorno_venc_seq'),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            nr_seq_retorno_p,
            trunc(clock_timestamp(),'dd') + qt_dias_venc_w);
    end if;

    if (coalesce(ie_trib_titulo_retorno_w,'N') in ('S','G')) then
        /*Ajuste para arredondamento do dos valores dos tributos calculados para a guia*/

        open C02;
        loop
        fetch C02 into	
            nr_titulo_w,
            vl_tributo_guia_total_w;
        EXIT WHEN NOT FOUND; /* apply on C02 */
            begin
            select	coalesce(sum(vl_tributo),0)
            into STRICT	vl_tributo_titulo_w
            from	titulo_receber_trib
            where	nr_titulo		= nr_titulo_w
            and	coalesce(ie_origem_tributo, 'C') in ('D','CD');

            if (vl_tributo_guia_total_w < vl_tributo_titulo_w) and
                (((vl_tributo_titulo_w - vl_tributo_guia_total_w) + vl_tributo_guia_total_w) = vl_tributo_titulo_w) then
                
                vl_diferenca_w  := vl_tributo_titulo_w - vl_tributo_guia_total_w;

                update	convenio_retorno_item a
                set	a.vl_tributo_guia	= vl_tributo_guia + (vl_tributo_titulo_w - vl_tributo_guia_total_w)
                where	a.nr_seq_retorno	= nr_seq_retorno_p
                and	a.nr_titulo		= nr_titulo_w
                and	a.vl_tributo_guia	> 0
                and	a.nr_sequencia		= 
                    (SELECT	max(x.nr_sequencia)
                    from	convenio_retorno_item x
                    where	x.nr_seq_retorno	= a.nr_seq_retorno
                    and	x.nr_titulo		= a.nr_titulo
                    and	x.vl_tributo_guia	> vl_diferenca_w);

            end if;		

            end;
        end loop;
        close C02;

    end if;
end if;
if (ie_commit_p = 'S') then
	commit;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_retorno_convenio ( nr_seq_retorno_p bigint, nm_usuario_p text, ie_lote_recurso_p text, ie_commit_p text) FROM PUBLIC;

