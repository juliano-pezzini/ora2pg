-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_amenor_tit_rec ( nr_titulo_p bigint, dt_parametro_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_amenor_w		double precision	:= 0;
vl_guia_w		double precision;
vl_pago_w		double precision;
vl_glosa_w		double precision;
ie_titulo_receber_w	varchar(255);
nr_interno_conta_w	bigint;
cd_estabelecimento_w	bigint;
cd_convenio_w		bigint;
ie_tit_ret_senha_w	varchar(255);
nr_seq_protocolo_w	double precision;
vl_grg_w		double precision;
vl_amenor_grg_w		double precision;
nr_seq_lote_prot_w	titulo_receber.NR_SEQ_LOTE_PROT%type;

c01 CURSOR FOR
SELECT	a.nr_interno_conta
from	titulo_receber a
where	a.nr_titulo		= nr_titulo_p

union all

SELECT	a.nr_interno_conta
from	conta_paciente a,
	titulo_receber b
where	a.nr_seq_protocolo	= b.nr_seq_protocolo
and	b.nr_titulo		= nr_titulo_p;


BEGIN

begin
select	max(nr_interno_conta),
	max(cd_estabelecimento),
	max(cd_convenio_conta),
	max(nr_seq_protocolo),
	max(NR_SEQ_LOTE_PROT)
into STRICT	nr_interno_conta_w,
	cd_estabelecimento_w,
	cd_convenio_w,
	nr_seq_protocolo_w,
	nr_seq_lote_prot_w
from 	titulo_receber
where	nr_titulo = nr_titulo_p;
exception
	when no_data_found then
		nr_interno_conta_w := null;
end;

if (nr_interno_conta_w IS NOT NULL AND nr_interno_conta_w::text <> '') or (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') or (nr_seq_lote_prot_w IS NOT NULL AND nr_seq_lote_prot_w::text <> '') then

	select	coalesce(max(ie_tit_ret_senha),'N')
	into STRICT	ie_tit_ret_senha_w
	from	convenio_estabelecimento
	where	cd_convenio		= cd_convenio_w
	and	cd_estabelecimento	= cd_estabelecimento_w;

	if (ie_tit_ret_senha_w = 'S') then

		select 	coalesce(sum(a.vl_guia),0) + vl_guia_w
		into STRICT	vl_guia_w
		from	conta_paciente_guia a,
			(SELECT distinct
				y.nr_interno_conta,
				y.cd_autorizacao
			from	convenio_retorno x,
				convenio_retorno_item y
			where	y.nr_seq_retorno			= x.nr_sequencia
			and	x.ie_status_retorno			= 'F'
			and	y.nr_titulo				= nr_titulo_p
			and	coalesce(x.dt_baixa_cr,dt_parametro_p) 	<= dt_parametro_p) b
		where	a.nr_interno_conta				= b.nr_interno_conta
		and	a.cd_autorizacao				<> b.cd_autorizacao
		and	obter_senha_atendimento(a.nr_atendimento)	= b.cd_autorizacao;

	else

		select	coalesce(sum(a.vl_guia),0)
		into STRICT	vl_guia_w
		from	conta_paciente_guia a,
			(SELECT distinct
				y.nr_interno_conta,
				y.cd_autorizacao
			from	convenio_retorno x,
				convenio_retorno_item y
			where	y.nr_seq_retorno			= x.nr_sequencia
			and	x.ie_status_retorno			= 'F'
			and	y.nr_titulo				= nr_titulo_p
			and	coalesce(x.dt_baixa_cr,dt_parametro_p)	<= dt_parametro_p) b
		where	a.nr_interno_conta	= b.nr_interno_conta
		and	a.cd_autorizacao	= b.cd_autorizacao;

	end if;

	if (vl_guia_w = 0) then

		begin

		select 	obter_valor_conv_estab(cd_convenio_parametro, cd_estabelecimento,'IE_TITULO_RECEBER')
		into STRICT	ie_titulo_receber_w
		from 	conta_paciente
		where	nr_interno_conta = nr_interno_conta_W;
		exception
			when	no_data_found then
				ie_titulo_receber_w := null;
		end;

		if (ie_titulo_receber_w = 'C') then
			select	sum(coalesce(a.vl_guia,0))
			into STRICT	vl_guia_w
			from	conta_paciente_guia a,
				(SELECT distinct
					y.nr_interno_conta,
					y.cd_autorizacao
				from	convenio_retorno x,
					convenio_retorno_item y
				where	y.nr_seq_retorno			= x.nr_sequencia
				and	x.ie_status_retorno			= 'F'
				and	y.nr_titulo				= nr_titulo_p
				and	coalesce(x.dt_baixa_cr,dt_parametro_p)	<= dt_parametro_p) b
			where	a.nr_interno_conta				= b.nr_interno_conta;

		end if;

	end if;

	select 	sum(coalesce(vl_recebido,0) + coalesce(vl_glosa,0))
	into STRICT	vl_pago_w
	from	titulo_receber_liq
	where	nr_titulo		= nr_titulo_p
	and	(nr_seq_retorno IS NOT NULL AND nr_seq_retorno::text <> '')
	and	coalesce(ie_lib_caixa, 'S') 	= 'S'
	and	dt_recebimento		<= dt_parametro_p;

	vl_amenor_w			:= coalesce(vl_guia_w,0) - coalesce(vl_pago_w,0);

	if (vl_amenor_w	> 0) then
	
		vl_amenor_grg_w := 0;
	
		/*lhalves OS 382935 em 22/11/2011 - Substituida a function obter_titulo_conta_guia pelo cursor*/

		open C01;
		loop
		fetch C01 into	
			nr_interno_conta_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			
			/* ahoffelder - OS 335577 - 09/08/2011 - nao trazer o amenor se a guia estiver em reapresentacao na GRG */

			select	coalesce(sum(b.vl_amenor),0) + coalesce(sum(b.vl_glosa),0) + coalesce(sum(b.vl_pago),0)
			into STRICT	vl_grg_w
			from	lote_audit_hist c,
				lote_audit_hist_item b,
				lote_audit_hist_guia a
			where	obter_ultima_analise(c.nr_seq_lote_audit)	= c.nr_sequencia
			and	a.nr_seq_lote_hist	= c.nr_sequencia
			and	a.nr_sequencia		= b.nr_seq_guia
			and	a.nr_interno_conta	= nr_interno_conta_w;

			vl_amenor_grg_w	:= vl_amenor_grg_w + coalesce(vl_grg_w,0);	
			
		end loop;
		close C01;
		
		vl_amenor_w	:= vl_amenor_w - coalesce(vl_amenor_grg_w,0);	
		
	end if;
	
	if (vl_amenor_w < 0) then
		vl_amenor_w	:= 0;
	end if;

end if;

return vl_amenor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_amenor_tit_rec ( nr_titulo_p bigint, dt_parametro_p timestamp) FROM PUBLIC;

