-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_qtd_oc_conta ( nr_sequencia_p bigint, ie_tipo_item_p bigint, qt_liberada_p bigint, ie_tipo_qtde_p text, qt_tipo_quantidade_p bigint, ie_tipo_pessoa_qtde_p text, ie_regra_tipo_quant_p text, ie_somar_estrutura_p text, nr_seq_estrutura_p bigint, nr_seq_ocorrencia_p bigint, ie_qt_lib_posterior_p text, cd_estabelecimento_p text, nm_usuario_p text ) RETURNS varchar AS $body$
DECLARE


/* IE_TIPO_ITEM_P
	1 - Procedimento da Autorização
	2 - Material da Autorização
	21 -  Procedimento da importação
	22 - Material da Importação
*/
/* IE_TIPO_QTDE_P - Domínio 3540
	D - Dia
	M - Mês
	A - Ano
	G - Guia
	C - Conta
*/
ie_retorno_w			varchar(1)	:= 'S';
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_material_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_prestador_w		bigint;
nr_seq_guia_plano_w		bigint;
qt_solicitada_w			double precision	:= 0;
qt_liberacao_w			double precision	:= 0;
qt_liberacao_ww			double precision	:= 0;
dt_liberacao_w			timestamp;
dt_liberacao_ww			timestamp;
cd_guia_w			varchar(20);
cd_medico_executor_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_conta_ww			bigint;
nr_seq_conta_proc_w		bigint;
cd_medico_solic_w		bigint;
nr_seq_proc_ref_w		bigint;
nr_seq_req_proc_w		bigint;
cd_procedimento_ww		bigint;
ie_origem_proced_ww		bigint;
qt_procedimento_w		bigint;
nr_seq_conta_mat_w		bigint;
ds_retorno_w			varchar(4000)	:= '';
ie_tipo_conta_w			varchar(10);
nr_seq_fatura_w			ptu_fatura.nr_fatura%type;
cd_congenere_w			varchar(20);
nr_seq_nota_cobranca_w		ptu_nota_cobranca.nr_nota%type;
cd_guia_ww			varchar(20);

C01 CURSOR FOR
	SELECT 	case when(a.ie_status('A','P','C')) then coalesce(a.qt_procedimento_imp,0)	--Diego 11/05/2011 OS 314640 - No caso do item estar em Análise, Pendente  ou Consistido o sistema utiliza a qt apresentada
		     else coalesce(a.qt_procedimento,0)						-- No demais é a quantia liberada
		end,
		b.nr_sequencia,
		a.nr_sequencia nr_seq_conta_proc
	from	pls_conta		b,
		pls_conta_proc		a
	where	a.nr_seq_conta			= b.nr_sequencia
	and	b.ie_status			<> 'C'
	and	a.ie_status			in ('A','S','P','C','L') /* Em Análise,  Liberado pelo Sistema, Pendente de Liberação, Consistido, Liberado pelo usuário */
	and	((coalesce(a.nr_seq_proc_ref::text, '') = '') or ( exists (SELECT 1 from pls_conta_proc x where a.nr_seq_proc_ref = x.nr_sequencia and x.ie_status = 'D')))/*Diego OS 314640 - Eliminar procedimentos referenciados*/
	and (b.nr_seq_prestador_exec 	= nr_seq_prestador_w and ie_tipo_pessoa_qtde_p = 'P')
	and	(((ie_tipo_qtde_p not in ('G','C')) and (trunc(coalesce(a.dt_procedimento,b.dt_emissao)) between dt_liberacao_ww and trunc(dt_liberacao_w))) or
		 ((ie_tipo_qtde_p = 'G') and (coalesce(b.cd_guia_referencia,b.cd_guia) = cd_guia_w)) or
		 (ie_tipo_qtde_p = 'C' AND b.nr_sequencia = nr_seq_conta_w))
	and	((ie_regra_tipo_quant_p = 'N') or (b.cd_medico_executor = cd_medico_executor_w))
	and	(((ie_somar_estrutura_p = 'N') and (a.cd_procedimento = cd_procedimento_w) and (a.ie_origem_proced = ie_origem_proced_w))--ie_origem_proced_w
	or	 ((ie_somar_estrutura_p = 'S')  and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')))
	and	not exists (select	1 from pls_ocorrencia_benef x	where x.nr_seq_conta_proc = a.nr_sequencia and x.nr_seq_ocorrencia = nr_seq_ocorrencia_p)
	
union

	select 	case when(a.ie_status in ('A','P','C')) then coalesce(a.qt_procedimento_imp,0)	--Diego 11/05/2011 OS 314640 - No caso do item estar em Análise, Pendente  ou Consistido o sistema utiliza a qt apresentada
		     else coalesce(a.qt_procedimento,0)						-- No demais é a quantia liberada
		end,
		b.nr_sequencia,
		a.nr_sequencia nr_seq_conta_proc
	from	pls_conta		b,
		pls_conta_proc		a
	where	a.nr_seq_conta			= b.nr_sequencia
	and	b.ie_status			<> 'C'
	and	a.ie_status			in ('A','S','P','C','L') /* Em Análise,  Liberado pelo Sistema, Pendente de Liberação, Consistido, Liberado pelo usuário */
	and	((coalesce(a.nr_seq_proc_ref::text, '') = '') or ( exists (select 1 from pls_conta_proc x where a.nr_seq_proc_ref = x.nr_sequencia and x.ie_status = 'D')))/*Diego OS 314640 - Eliminar procedimentos referenciados*/
	and (b.nr_seq_segurado		= nr_seq_segurado_w and ie_tipo_pessoa_qtde_p  = 'B')
	and	(((ie_tipo_qtde_p not in ('G','C')) and (trunc(coalesce(a.dt_procedimento,b.dt_emissao)) between dt_liberacao_ww and trunc(dt_liberacao_w))) or
		 ((ie_tipo_qtde_p = 'G') and (coalesce(b.cd_guia_referencia,b.cd_guia) = cd_guia_w)) or
		 (ie_tipo_qtde_p = 'C' AND b.nr_sequencia = nr_seq_conta_w))
	and	((ie_regra_tipo_quant_p = 'N') or (b.cd_medico_executor = cd_medico_executor_w))
	and	(((ie_somar_estrutura_p = 'N') and (a.cd_procedimento = cd_procedimento_w) and (a.ie_origem_proced = ie_origem_proced_w))--ie_origem_proced_w
	or	 ((ie_somar_estrutura_p = 'S')  and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, a.cd_procedimento, a.ie_origem_proced, null) = 'S')))
	and	not exists (select	1 from pls_ocorrencia_benef x	where x.nr_seq_conta_proc = a.nr_sequencia and x.nr_seq_ocorrencia = nr_seq_ocorrencia_p)
	order by
		nr_seq_conta_proc;
C02 CURSOR FOR
	SELECT 	case when(a.ie_status('A','P','C')) then coalesce(a.qt_material_imp,0)	--Diego 11/05/2011 OS 314640 - No caso do item estar em Análise, Pendente  ou Consistido o sistema utiliza a qt apresentada
		     else coalesce(a.qt_material,0)								    	     -- No demais é a quantia liberada
		end,
		b.nr_sequencia,
		a.nr_sequencia
	from	pls_conta		b,
		pls_conta_mat		a
	where	a.nr_seq_conta			= b.nr_sequencia
	and	b.ie_status			<> 'C'
	and	a.ie_status			in ('A','S','P','C','L')
	and	((b.nr_seq_segurado		= nr_seq_segurado_w and ie_tipo_pessoa_qtde_p  = 'B')
	or (b.nr_seq_prestador_exec	= nr_seq_prestador_w and ie_tipo_pessoa_qtde_p = 'P'))
	and	(((ie_tipo_qtde_p not in ('G','C')) and (trunc(coalesce(a.dt_atendimento,b.dt_emissao)) between dt_liberacao_ww and trunc(dt_liberacao_w))) or
		((ie_tipo_qtde_p = 'G') and (coalesce(b.cd_guia_referencia,b.cd_guia) = cd_guia_w)) or
		(ie_tipo_qtde_p = 'C' AND b.nr_sequencia = nr_seq_conta_w))
	and	((ie_regra_tipo_quant_p = 'N') or (b.cd_medico_executor = cd_medico_executor_w))
	and	((ie_somar_estrutura_p = 'N' AND a.nr_seq_material = nr_seq_material_w)
	or	((ie_somar_estrutura_p = 'S')  and (pls_obter_se_estrut_ocorrencia(nr_seq_estrutura_p, null, null, a.nr_seq_material) = 'S')));


BEGIN
if (ie_tipo_item_p	= 3) then
	select	a.cd_procedimento,
		a.ie_origem_proced,
		coalesce(a.dt_procedimento,b.dt_emissao),
		b.nr_seq_segurado,
		b.nr_seq_prestador_exec,
		coalesce(b.cd_guia_referencia, b.cd_guia),
		b.cd_medico_executor,
		b.nr_sequencia,
		a.nr_seq_proc_ref
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		dt_liberacao_w,
		nr_seq_segurado_w,
		nr_seq_prestador_w,
		cd_guia_w,
		cd_medico_executor_w,
		nr_seq_conta_w,
		nr_seq_proc_ref_w
	from	pls_conta	b,
		pls_conta_proc	a
	where	a.nr_seq_conta	= b.nr_sequencia
	and	a.nr_sequencia	= nr_sequencia_p;
elsif (ie_tipo_item_p	= 4) then
	select	a.nr_seq_material,
		coalesce(a.dt_atendimento,b.dt_emissao),
		b.nr_seq_segurado,
		b.nr_seq_prestador_exec,
		b.cd_medico_executor,
		b.nr_sequencia,
		coalesce(b.cd_guia_referencia, b.cd_guia)
	into STRICT	nr_seq_material_w,
		dt_liberacao_w,
		nr_seq_segurado_w,
		nr_seq_prestador_w,
		cd_medico_executor_w,
		nr_seq_conta_w,
		cd_guia_w
	from	pls_conta	b,
		pls_conta_mat	a
	where	a.nr_seq_conta	= b.nr_sequencia
	and	a.nr_sequencia	= nr_sequencia_p;
elsif (ie_tipo_item_p = 21) then/* Procedimento da  conta - importação */
	begin
	select	a.cd_procedimento_imp,
		a.ie_origem_proced,
		coalesce(a.dt_procedimento_imp,b.dt_emissao_imp),
		substr(pls_obter_segurado_carteira(b.cd_usuario_plano_imp,cd_estabelecimento_p),1,10),
		b.nr_seq_prestador_exec_imp,
		coalesce(b.cd_guia_solic_imp, b.cd_guia_imp),
		coalesce(b.cd_medico_executor_imp,substr(pls_obter_dados_gerar_conta(b.nr_Sequencia,'M'),1,20)),
		b.nr_sequencia
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		dt_liberacao_w,
		nr_seq_segurado_w,
		nr_seq_prestador_w,
		cd_guia_w,
		cd_medico_executor_w,
		nr_seq_conta_w
	from	pls_conta	b,
		pls_conta_proc	a
	where	a.nr_seq_conta		= b.nr_sequencia
	and	a.nr_sequencia		= nr_sequencia_p;
	exception
	when others then
		cd_procedimento_w	:= '';
	end;
elsif (ie_tipo_item_p = 22) then/* Material da  conta - importação*/
	begin
	select	a.nr_seq_material,
		coalesce(a.dt_atendimento_imp,b.dt_emissao_imp),
		substr(pls_obter_segurado_carteira(b.cd_usuario_plano_imp,cd_estabelecimento_p),1,10),
		b.nr_seq_prestador_exec_imp,
		coalesce(b.cd_medico_executor_imp,substr(pls_obter_dados_gerar_conta(b.nr_Sequencia,'M'),1,20) ),
		b.nr_sequencia,
		coalesce(b.cd_guia_solic_imp, b.cd_guia_imp)
	into STRICT	nr_seq_material_w,
		dt_liberacao_w,
		nr_seq_segurado_w,
		nr_seq_prestador_w,
		cd_medico_executor_w,
		nr_seq_conta_w,
		cd_guia_w
	from	pls_conta	b,
		pls_conta_mat	a
	where	a.nr_seq_conta		= b.nr_sequencia
	and	a.nr_sequencia		= nr_sequencia_p;
	exception
	when others then
		nr_seq_material_w	:= 0;
	end;
end if;

if (ie_tipo_qtde_p	= 'D') then
	/*Diego OPS - OS 284525 - Tratamento realizado para que seja mantida uma lógica quanto a quantiade de dias.
			        Ou seja anteriormente se quisese que o não pode-se repetir o proedimento duas vezes no mesmo dia eu teria que cadastrar
			        a qt_dias como zero o que dificultava o entendimento do cliente.
	dt_liberacao_ww	:= trunc(dt_liberacao_w - qt_tipo_quantidade_p);*/
	dt_liberacao_ww	:= trunc(dt_liberacao_w - (qt_tipo_quantidade_p - 1));

	if (ie_qt_lib_posterior_p	= 'S') then
		dt_liberacao_w	:= trunc(dt_liberacao_w + (qt_tipo_quantidade_p - 1));
	end if;
elsif (ie_tipo_qtde_p	= 'M') then
	/*Diego OPS - OS 284577 - Removi os truncs por month pois pela definição do cliente deve-se haver a lógica de ano precisa.
	    Ou seja existindo a regra de 2º incidencia em 1 ano, eu posso executar hoje a exatamente 366 dias após.*/
	dt_liberacao_ww	:= (add_months(dt_liberacao_w, -qt_tipo_quantidade_p) + 1);

	if (ie_qt_lib_posterior_p	= 'S') then
		dt_liberacao_w	:= (add_months(dt_liberacao_w, qt_tipo_quantidade_p) + 1);
	end if;
elsif (ie_tipo_qtde_p	= 'A') then
	/*Diego OPS - OS 284577 - A lógica vista com o Srº Felipe Ambrósio é de que ao executar o procedimento dia 26/01/2011 poderei executa-lo exatamente dia 26/01/2012*/

	dt_liberacao_ww	:= (add_months(dt_liberacao_w, -qt_tipo_quantidade_p * 12) + 1); /* Vezes 12 meses ao ano */
	if (ie_qt_lib_posterior_p	= 'S') then
		dt_liberacao_w	:= (add_months(dt_liberacao_w, qt_tipo_quantidade_p * 12) + 1); /* Vezes 12 meses ao ano */
	end if;
elsif (ie_tipo_qtde_p = 'G') then
	dt_liberacao_ww := clock_timestamp();
end if;

/*
';nr_seq_segurado_w='||chr(39)||nr_seq_segurado_w||chr(39)||
';ie_tipo_pessoa_qtde_p='||chr(39)||ie_tipo_pessoa_qtde_p||chr(39)||
';nr_seq_prestador_w='||chr(39)||nr_seq_prestador_w||chr(39)||
';ie_tipo_qtde_p='||chr(39)||||chr(39)||
';dt_liberacao_ww='||chr(39)||dt_liberacao_ww||chr(39)||
';dt_liberacao_w='||chr(39)||dt_liberacao_w||chr(39)||
';cd_guia_w='||chr(39)||cd_guia_w||chr(39)||
';nr_seq_conta_w='||chr(39)||nr_seq_conta_w||chr(39)||
';ie_regra_tipo_quant_p='||chr(39)||ie_regra_tipo_quant_p||chr(39)||
';cd_medico_executor_w='||chr(39)||cd_medico_executor_w||chr(39)||
';cd_procedimento_w='||chr(39)||cd_procedimento_w||chr(39)||
';ie_origem_proced_w='||chr(39)||ie_origem_proced_w||chr(39)||
';ie_somar_estrutura_p='||chr(39)||ie_somar_estrutura_p||chr(39)||
';nr_seq_estrutura_p='||chr(39)||nr_seq_estrutura_p||chr(39)||
';nr_seq_ocorrencia_p='||chr(39)||nr_seq_ocorrencia_p||chr(39)||
';nr_seq_proc_ref_w='||chr(39)||nr_seq_proc_ref_w||chr(39)
*/
if (ie_tipo_item_p	in (3, 21)) then
	open C01;
	loop
	fetch C01 into
		qt_liberacao_w,
		nr_seq_conta_ww,
		nr_seq_conta_proc_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_liberacao_ww	:= qt_liberacao_ww + qt_liberacao_w;


		--jjung -  Verificar se é conta de intercâmbio e se for já obtem os dados para usar na observação da Ocorrência, solicitado por Felipe - USJRP
		begin
		select	a.ie_tipo_conta,
			c.nr_fatura,
			pls_obter_seq_codigo_coop(d.nr_seq_congenere,''),
			b.nr_nota,
			a.cd_guia
		into STRICT	ie_tipo_conta_w,
			nr_seq_fatura_w,
			cd_congenere_w,
			nr_seq_nota_cobranca_w,
			cd_guia_ww
		from	pls_conta		a,
			ptu_nota_cobranca	b,
			ptu_fatura		c,
			pls_protocolo_conta	d
		where	a.nr_sequencia = nr_seq_conta_ww
		and	a.nr_seq_nota_cobranca = b.nr_sequencia
		and	((a.nr_seq_fatura = c.nr_sequencia) or (b.nr_seq_fatura = c.nr_sequencia))
		and	d.nr_sequencia = a.nr_seq_protocolo
		and	a.ie_tipo_conta = 'I';
		exception
		when no_data_found then
			ie_tipo_conta_w		:= null;
			nr_seq_fatura_w		:= null;
			cd_congenere_w		:= null;
			nr_seq_nota_cobranca_w	:= null;
		end;
		/*Se for contas diferentes ou a quantidade for maior que a permitida*/

		if (nr_sequencia_p <> nr_seq_conta_proc_w) or (qt_liberacao_ww >= qt_liberada_p)	then

			ds_retorno_w := substr(ds_retorno_w||'Conta: '||nr_seq_conta_ww||' | Guia: '||cd_guia_ww||' | Seq. proc.: '||nr_seq_conta_proc_w||
					' | Quant.: '||qt_liberacao_w||chr(13)||chr(10),1,4000);

			if (ie_tipo_conta_w IS NOT NULL AND ie_tipo_conta_w::text <> '') then
				if (ie_tipo_conta_w = 'I') then
					ds_retorno_w := substr(ds_retorno_w||'Nr. Nota Cob.: '||nr_seq_nota_cobranca_w||' | Nr. Fatura: '||nr_seq_fatura_w||
					' | Cód. Operadora: '||cd_congenere_w||chr(13)||chr(10),1,4000);
				end if;
			end if;

		end if;
		end;
	end loop;
	close C01;
elsif (ie_tipo_item_p	in (4,22)) then
	open C02;
	loop
	fetch C02 into
		qt_liberacao_w,
		nr_seq_conta_ww,
		nr_seq_conta_mat_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		qt_liberacao_ww := qt_liberacao_ww + qt_liberacao_w;

		--jjung -  Verificar se é conta de intercâmbio e se for já obtem os dados para usar na observação da Ocorrência, solicitado por Felipe - USJRP
		begin
			select	a.ie_tipo_conta,
				c.nr_fatura,
				pls_obter_seq_codigo_coop(d.nr_seq_congenere,''),
				b.nr_nota,
				a.cd_guia
			into STRICT	ie_tipo_conta_w,
				nr_seq_fatura_w,
				cd_congenere_w,
				nr_seq_nota_cobranca_w,
				cd_guia_ww
			from	pls_conta		a,
				ptu_nota_cobranca	b,
				ptu_fatura		c,
				pls_protocolo_conta	d
			where	a.nr_sequencia = nr_seq_conta_ww
			and	a.nr_seq_nota_cobranca = b.nr_sequencia
			and	((a.nr_seq_fatura = c.nr_sequencia) or (b.nr_seq_fatura = c.nr_sequencia))
			and	d.nr_sequencia = a.nr_seq_protocolo
			and	a.ie_tipo_conta = 'I';
		exception
		when no_data_found then
			ie_tipo_conta_w		:= null;
			nr_seq_fatura_w		:= null;
			cd_congenere_w		:= null;
			nr_seq_nota_cobranca_w	:= null;
		end;

		if (nr_sequencia_p <> nr_seq_conta_mat_w)  or (qt_liberacao_ww >= qt_liberada_p)	then

			ds_retorno_w := substr(ds_retorno_w||'Conta: '||nr_seq_conta_ww||' | Guia: '||cd_guia_ww||' | Seq. mat.: '||nr_seq_conta_mat_w||
					' | Quant.: '||qt_liberacao_w||chr(13)||chr(10),1,4000);
			if (ie_tipo_conta_w IS NOT NULL AND ie_tipo_conta_w::text <> '') then
				if (ie_tipo_conta_w = 'I') then
					ds_retorno_w := substr(ds_retorno_w||'Nr. Nota Cob.: '||nr_seq_nota_cobranca_w||' | Nr. Fatura: '||nr_seq_fatura_w||
					' | Cód. Operadora: '||cd_congenere_w||chr(13)||chr(10),1,4000);
				end if;
			end if;
		end if;
		end;
	end loop;
	close C02;
end if;

--qt_liberacao_w := qt_liberacao_ww + qt_solicitada_w;
/*Diego /Alexandre  - OS 264139 - Obs: retirado a verificação do qt_liberacao_w for igual ao qt_liberada_p  */

/*Djavan - OS 277771 - Obs: Alterada a comparação "if (qt_liberacao_w	> qt_liberada_p) then", para "if (qt_liberacao_w	>= qt_liberada_p) then", por solicitação do Adriano*/

if (not(qt_liberacao_ww >= qt_liberada_p)) then
	ds_retorno_w	:= '';

else
	if (ds_retorno_w <> '') then
		ds_retorno_w := substr(ds_retorno_w||'Quantidade permitida pela regra: '||(qt_liberada_p-1)||chr(13)||chr(10),1,4000);
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_qtd_oc_conta ( nr_sequencia_p bigint, ie_tipo_item_p bigint, qt_liberada_p bigint, ie_tipo_qtde_p text, qt_tipo_quantidade_p bigint, ie_tipo_pessoa_qtde_p text, ie_regra_tipo_quant_p text, ie_somar_estrutura_p text, nr_seq_estrutura_p bigint, nr_seq_ocorrencia_p bigint, ie_qt_lib_posterior_p text, cd_estabelecimento_p text, nm_usuario_p text ) FROM PUBLIC;

