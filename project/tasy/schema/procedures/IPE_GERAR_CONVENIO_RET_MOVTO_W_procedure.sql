-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE conta AS (nr_interno_conta	bigint, cd_usuario_convenio varchar(255), nr_nota varchar(255), nr_sequencia bigint);


CREATE OR REPLACE PROCEDURE ipe_gerar_convenio_ret_movto_w (nr_seq_retorno_p bigint) AS $body$
DECLARE

type vetor_conta is table of conta index by integer;

vetor_conta_w		vetor_conta;
nr_doc_convenio_arq_w	varchar(255);
nr_doc_convenio_w	varchar(255);
cd_usuario_conv_w	varchar(255);
cd_usuario_conv_arq_w	varchar(255);
cd_item_w		bigint;
vl_total_pago_w		double precision;
vl_glosado_w		double precision;
vl_cobrado_w		double precision;
vl_pago_arq_w		double precision;
vl_glosado_arq_w	double precision;
vl_cobrado_arq_w	double precision;
cd_motivo_glosa_w	bigint;
ie_tipo_w		varchar(255);
nm_beneficiario_w	varchar(255);
nr_nota_arq_w		varchar(255);
nr_nota_w		varchar(255);
nr_linha_w		varchar(10);
cd_convenio_w		bigint;
nr_interno_conta_w	bigint;
nr_seq_protocolo_w	bigint;
nm_paciente_w		varchar(255);
nr_seq_item_conta_w	bigint;
nr_sequencia_w		bigint;
dt_item_w		varchar(20);
ie_gerar_resumo_w	varchar(1);
dt_ano_conta_w		varchar(4);
dt_execucao_w		timestamp;
nr_seq_movto_w		bigint;
ds_conteudo_w		varchar(4000);
count_w			bigint;
nr_seq_inicial_w	bigint;
nr_seq_final_w		bigint;
nr_min_seq_w		bigint;
nr_max_seq_w		bigint;
cd_brasindice_w		varchar(255);
qt_pcnc_w		bigint;
dia_ini_w		bigint;
cd_user_conv_w		convenio_retorno_movto.cd_usuario_convenio%type;
nr_seq_protocolo_ww	protocolo_convenio.nr_seq_protocolo%type;
valor_conta_w		conta_paciente.vl_conta%type;
valor_conta_arq_w	conta_paciente.vl_conta%type;

i			integer;
k			integer;
j			integer;

c00 CURSOR FOR 
SELECT	substr(ds_conteudo,68,5) nr_nota, 
	substr(ds_conteudo,20,13) cd_usuario_convenio, 
	nr_sequencia 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p 
and	substr(ds_conteudo,14,4)	in ('0075','0076','0077','0085','0086') 
and	substr(ds_conteudo,1,3) 	<> 'SMH' 
order by nr_sequencia;

c00_w	c00%rowtype;	
 
c01 CURSOR FOR 
SELECT	substr(ds_conteudo,14,2) nr_linha, 
	substr(ds_conteudo,14,4) ie_tipo, 
	substr(ds_conteudo,62,6) nr_doc_convenio, 
	substr(ds_conteudo,68,5) nr_nota, 
	substr(ds_conteudo,20,13) cd_usuario_convenio, 
	somente_numero(substr(ds_conteudo,38,8)) cd_item, 
	somente_numero(substr(ds_conteudo,70,13)) vl_total_pago, 
	somente_numero(substr(ds_conteudo,83,9)) vl_glosado, 
	somente_numero(substr(ds_conteudo,59,11)) vl_cobrado, 
	null nm_paciente, 
	substr(ds_conteudo,20,4) dt_item, 
	'S' ie_gera_resumo, 
	ds_conteudo, 
	substr(ds_conteudo,70,12) cd_brasindice 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p 
and	substr(ds_conteudo,16,2)	in ('75','76','77', '85', '86') 
and	nr_sequencia between nr_seq_inicial_w + 1 and nr_seq_final_w - 1 
and	substr(ds_conteudo,1,3) 	<> 'SMH';

c02 CURSOR FOR 
SELECT	substr(ds_conteudo,1,2) nr_linha, 
	substr(ds_conteudo,1,4) ie_tipo, 
	null nr_doc_convenio, 
	substr(ds_conteudo,49,5) nr_nota, 
	substr(ds_conteudo,3,13) cd_usuario_convenio, 
	somente_numero(substr(ds_conteudo,26,08)) cd_item, 
	somente_numero(substr(ds_conteudo,145,13)) vl_total_pago, 
	somente_numero(substr(ds_conteudo,158,13)) vl_glosado, 
	somente_numero(substr(ds_conteudo,132,13)) vl_cobrado, 
	trim(both substr(ds_conteudo,39,43)) nm_paciente, 
	somente_numero(substr(ds_conteudo,24,2)) dia_conta, 
	somente_numero(substr(ds_conteudo,21,13)) valor_conta, 
	nr_sequencia 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p 
and	substr(ds_conteudo,1,3)		<> 'SMH' 
and	exists (SELECT	1 
	from	w_conv_ret_movto x 
	where	x.nr_seq_retorno	= nr_seq_retorno_p 
	and	substr(x.ds_conteudo,1,4) = '0035') 

union all
 
select	substr(ds_conteudo,1,2) nr_linha, 
	substr(ds_conteudo,1,4) ie_tipo, 
	null nr_doc_convenio, 
	substr(ds_conteudo,47,5) nr_nota, 
	substr(ds_conteudo,3,13) cd_usuario_convenio, 
	somente_numero(substr(ds_conteudo,18,08)) cd_item, 
	somente_numero(substr(ds_conteudo,113,13)) vl_total_pago, 
	somente_numero(substr(ds_conteudo,126,9)) vl_glosado, 
	somente_numero(substr(ds_conteudo,100,13)) vl_cobrado, 
	trim(both substr(ds_conteudo,55,45)) nm_paciente, 
	somente_numero(substr(ds_conteudo,24,2)) dia_conta, 
	somente_numero(substr(ds_conteudo,21,13)) valor_conta, 
	nr_sequencia 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p 
and	substr(ds_conteudo,1,3)		<> 'SMH' 
and	exists (select	1 
	from	w_conv_ret_movto x 
	where	x.nr_seq_retorno	= nr_seq_retorno_p 
	and	substr(x.ds_conteudo,1,4) = '0055') 
order by nr_sequencia;

c03 CURSOR FOR 
SELECT	substr(ds_conteudo,14,2) nr_linha, 
	substr(ds_conteudo,14,4) ie_tipo, 
	null nr_doc_convenio, 
	substr(ds_conteudo,68,5) nr_nota, 
	substr(ds_conteudo,20,13) cd_usuario_convenio, 
	somente_numero(substr(ds_conteudo,38,08)) cd_item, 
	somente_numero(substr(ds_conteudo,159,13)) vl_total_pago, 
	somente_numero(substr(ds_conteudo,168,9)) vl_glosado, 
	somente_numero(substr(ds_conteudo,146,13)) vl_cobrado, 
	null nm_paciente 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p 
and	substr(ds_conteudo,14,4)	= '0076' 
and	substr(ds_conteudo,1,3) 	<> 'SMH' 
order by nr_sequencia;

c04 CURSOR FOR 
SELECT	substr(ds_conteudo,14,2) nr_linha, 
	substr(ds_conteudo,14,4) ie_tipo, 
	substr(ds_conteudo,62,6) nr_doc_convenio, 
	substr(ds_conteudo,68,5) nr_nota, 
	substr(ds_conteudo,20,13) cd_usuario_convenio, 
	somente_numero(substr(ds_conteudo,39,8)) cd_item, 
	somente_numero(substr(ds_conteudo,146,13)) vl_total_pago, 
	somente_numero(substr(ds_conteudo,159,9)) vl_glosado, 
	somente_numero(substr(ds_conteudo,133,13)) vl_cobrado, 
	null nm_paciente 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p 
and	substr(ds_conteudo,14,4)	= '0085' 
and	substr(ds_conteudo,1,3) 	<> 'SMH' 
order by nr_sequencia;

c05 CURSOR FOR 
SELECT	substr(ds_conteudo,14,2) nr_linha, 
	substr(ds_conteudo,14,4) ie_tipo, 
	null nr_doc_convenio, 
	substr(ds_conteudo,68,5) nr_nota, 
	substr(ds_conteudo,20,13) cd_usuario_convenio, 
	somente_numero(substr(ds_conteudo,38,08)) cd_item, 
	somente_numero(substr(ds_conteudo,159,13)) vl_total_pago, 
	somente_numero(substr(ds_conteudo,168,9)) vl_glosado, 
	somente_numero(substr(ds_conteudo,146,13)) vl_cobrado, 
	null nm_paciente 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p 
and	substr(ds_conteudo,14,4)	= '0086' 
and	substr(ds_conteudo,1,3) 	<> 'SMH' 
order by nr_sequencia;

c06 CURSOR FOR 
SELECT	substr(ds_conteudo,14,2) nr_linha, 
	substr(ds_conteudo,14,4) ie_tipo, 
	null nr_doc_convenio, 
	substr(ds_conteudo,68,5) nr_nota, 
	substr(ds_conteudo,20,13) cd_usuario_convenio, 
	somente_numero(substr(ds_conteudo,38,08)) cd_item, 
	somente_numero(substr(ds_conteudo,146,13)) vl_total_pago, 
	somente_numero(substr(ds_conteudo,159,9)) vl_glosado, 
	somente_numero(substr(ds_conteudo,120,9)) vl_cobrado, 
	null nm_paciente 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p 
and	substr(ds_conteudo,14,4)	= '0077' 
and	substr(ds_conteudo,1,3) 	<> 'SMH' 
order by nr_sequencia;

c07 CURSOR FOR 
SELECT	cd_usuario_convenio 
from	convenio_retorno_movto a 
where	a.nr_seq_retorno = nr_seq_retorno_p 
and	((nr_conta = '') or (coalesce(nr_conta::text, '') = ''));


BEGIN 
 
delete 	from convenio_ret_movto_hist 
where	nr_seq_retorno	= nr_seq_retorno_p;
 
select	max(cd_convenio) 
into STRICT	cd_convenio_w 
from	convenio_retorno 
where	nr_sequencia	= nr_seq_retorno_p;
 
select	min(nr_sequencia), 
	max(nr_sequencia) 
into STRICT	nr_min_seq_w, 
	nr_max_seq_w 
from	w_conv_ret_movto 
where	nr_seq_retorno			= nr_seq_retorno_p;
 
count_w	:= 0;
 
nr_seq_inicial_w	:= 0;
i 			:= 1;
 
/*Primeiro carrega um vetor com todos os registros de conta do arquivo para os tipos 75,76,77 
Alem de gravar a conta, grava também a posição inicial e final de registro da conta, para identificar no arquivo onde começa e termina os itens desta conta.*/
 
open C00;
loop 
fetch C00 into	 
	c00_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin 
	 
	nr_nota_w		:= ltrim(c00_w.nr_nota,'0');
	cd_usuario_conv_w	:= c00_w.cd_usuario_convenio;
 
	select	max(a.nr_seq_protocolo) 
	into STRICT	nr_seq_protocolo_w 
	from	protocolo_convenio a 
	where	a.cd_convenio		= cd_convenio_w 
	and	a.ie_status_protocolo	= 2 
	and	exists (SELECT	1 
		from	conta_paciente x 
		where	x.nr_seq_protocolo	= a.nr_seq_protocolo 
		and	x.nr_conta_convenio	= nr_nota_w);
 
	if (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then 
 
		select	max(a.nr_interno_conta) 
		into STRICT	nr_interno_conta_w 
		from	conta_paciente a, 
			atend_categoria_convenio b 
		where	a.nr_atendimento	= b.nr_atendimento 
		and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
		and	a.nr_conta_convenio	= nr_nota_w 
		and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
		and	b.cd_usuario_convenio	= cd_usuario_conv_w 
		and	OBTER_SALDO_CONPACI(a.nr_interno_conta,null) <> 0;
 
	else 
		select	max(a.nr_interno_conta) 
		into STRICT	nr_interno_conta_w 
		from	conta_paciente a, 
			atend_categoria_convenio b 
		where	a.nr_atendimento	= b.nr_atendimento 
		and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
		and	a.ie_status_acerto	= 2 
		and	(a.nr_seq_protocolo IS NOT NULL AND a.nr_seq_protocolo::text <> '') 
		and	a.cd_convenio_parametro	= cd_convenio_w 
		and	a.nr_conta_convenio	= nr_nota_w 
		and	b.cd_usuario_convenio	= cd_usuario_conv_w 
		and	OBTER_SALDO_CONPACI(a.nr_interno_conta,null) <> 0;
 
	end if;	
	 
	vetor_conta_w[i].nr_interno_conta	:= nr_interno_conta_w;	
	vetor_conta_w[i].cd_usuario_convenio	:= cd_usuario_conv_w;
	vetor_conta_w[i].nr_nota		:= nr_nota_w;
	vetor_conta_w[i].nr_sequencia		:= c00_w.nr_sequencia;		
	 
	i	:= i + 1;	
	end;
end loop;
close C00;
 
i := vetor_conta_w.count;
 
for k in 1.. i loop 
	begin 
	 
	if (k = 0) then 
		nr_seq_inicial_w	:= nr_min_seq_w;
	else 
		nr_seq_inicial_w	:= vetor_conta_w[k].nr_sequencia;
	end if;	
	 
	begin 
		nr_seq_final_w	:= vetor_conta_w[k + 1].nr_sequencia;
	exception 
	when others then 
		nr_seq_final_w	:= nr_max_seq_w;
	end;	
 
	open C01;
	loop 
	fetch C01 into 
		nr_linha_w, 
		ie_tipo_w, 
		nr_doc_convenio_arq_w, 
		nr_nota_arq_w, 
		cd_usuario_conv_arq_w, 
		cd_item_w, 
		vl_pago_arq_w, 
		vl_glosado_arq_w, 
		vl_cobrado_arq_w, 
		nm_paciente_w, 
		dt_item_w, 
		ie_gerar_resumo_w, 
		ds_conteudo_w, 
		cd_brasindice_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */	
	 
		nr_seq_item_conta_w := null;
 
		select	to_char(coalesce(max(dt_mesano_referencia),clock_timestamp()),'yyyy') 
		into STRICT	dt_ano_conta_w 
		from	conta_paciente 
		where	nr_interno_conta	= vetor_conta_w[k].nr_interno_conta;
		 
		dt_execucao_w	:= null;
		 
		if (dt_item_w IS NOT NULL AND dt_item_w::text <> '') then 
			begin 
				dt_execucao_w	:= to_date(dt_ano_conta_w||dt_item_w,'yyyymmdd');
			exception 
			when others then 
				dt_execucao_w	:= null;
			end;			
		end if;	
		 
		vl_total_pago_w	:= 0;
		vl_glosado_w	:= 0;
		vl_cobrado_w	:= 0;		
		 
		if (substr(ie_tipo_w,3,4) in ('76','86')) then	 
			vl_pago_arq_w		:= somente_numero(substr(ds_conteudo_w,82,13));
			vl_glosado_arq_w	:= somente_numero(substr(ds_conteudo_w,95,9));
			vl_cobrado_arq_w	:= somente_numero(substr(ds_conteudo_w,59,11));	
 
			vl_total_pago_w		:= dividir(coalesce(vl_pago_arq_w,0),100);
			vl_glosado_w		:= dividir(coalesce(vl_glosado_arq_w,0),100);
			vl_cobrado_w		:= dividir(coalesce(vl_cobrado_arq_w,0),100);
		else		 
			vl_total_pago_w		:= dividir(coalesce(vl_pago_arq_w,0),100);
			vl_glosado_w		:= dividir(coalesce(vl_glosado_arq_w,0),100);
			vl_cobrado_w		:= dividir(coalesce(vl_cobrado_arq_w,0),100);
		end if;	
		 
		if (cd_item_w = '701') then --Quando 701, existe brasíndice 
 
			select	max(cd_material), 
				max(a.nr_sequencia) 
			into STRICT	cd_item_w, 
				nr_seq_item_conta_w 
			from	material_atend_paciente a, 
				conta_paciente b 
			where	a.nr_interno_conta	= b.nr_interno_conta 
			and	b.nr_interno_conta	= vetor_conta_w[k].nr_interno_conta 
			and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
			and	cd_brasindice_w		= (obter_dados_brasindice_seq(a.nr_seq_bras_preco,'CMED')|| 
								obter_dados_brasindice_seq(a.nr_seq_bras_preco,'CLAB')|| 
								obter_dados_brasindice_seq(a.nr_seq_bras_preco,'CAPR'));
 
			if (coalesce(nr_seq_item_conta_w::text, '') = '') then 
				select	max(cd_material), 
					max(a.nr_sequencia) 
				into STRICT	cd_item_w, 
					nr_seq_item_conta_w 
				from	material_atend_paciente a, 
					conta_paciente b 
				where	a.nr_interno_conta	= b.nr_interno_conta 
				and	b.nr_interno_conta	= vetor_conta_w[k].nr_interno_conta 
				and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
				and	cd_brasindice_w		= (	Obter_Dados_Brasindice(b.cd_estabelecimento,a.cd_material,a.dt_atendimento,b.cd_convenio_parametro,'CMED')|| 
									Obter_Dados_Brasindice(b.cd_estabelecimento,a.cd_material,a.dt_atendimento,b.cd_convenio_parametro,'CLAB')|| 
									Obter_Dados_Brasindice(b.cd_estabelecimento,a.cd_material,a.dt_atendimento,b.cd_convenio_parametro,'CAPR'));
			end if;			
		end if;
		 
		if (coalesce(nr_seq_item_conta_w::text, '') = '') then 
 
			select	max(nr_sequencia)			 
			into STRICT	nr_seq_item_conta_w			 
			from	procedimento_paciente 
			where	nr_interno_conta		= vetor_conta_w[k].nr_interno_conta 
			and	coalesce(cd_motivo_exc_conta::text, '') = '' 
			and (cd_procedimento		= cd_item_w or 
				cd_procedimento_convenio	= cd_item_w or 
				cd_procedimento_tuss		= cd_item_w);
 
			if (coalesce(nr_seq_item_conta_w::text, '') = '') then 
 
				select	max(nr_sequencia) 
				into STRICT	nr_seq_item_conta_w 
				from	material_atend_paciente 
				where	nr_interno_conta			= vetor_conta_w[k].nr_interno_conta 
				and	coalesce(cd_motivo_exc_conta::text, '') = '' 
				and (cd_material				= cd_item_w or 
					cd_material_convenio			= cd_item_w or 
					somente_numero(cd_material_tiss)	= cd_item_w);
			end if;
		end if;
		 
		select	nextval('convenio_retorno_movto_seq') 
		into STRICT	nr_seq_movto_w 
		;	
 
		insert into convenio_retorno_movto(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_retorno, 
			nr_doc_convenio, 
			cd_usuario_convenio, 
			cd_item, 
			vl_total_pago, 
			vl_glosa, 
			ds_complemento, 
			vl_pago, 
			vl_cobrado, 
			nr_conta, 
			ie_gera_resumo, 
			dt_execucao, 
			nr_seq_item_conta) 
		values (nr_seq_movto_w, 
			clock_timestamp(), 
			'Tasy_Imp', 
			nr_seq_retorno_p, 
			nr_doc_convenio_w, 
			vetor_conta_w[k].cd_usuario_convenio, 
			cd_item_w, 
			vl_total_pago_w, 
			vl_glosado_w, 
			'c01 TR '|| ie_tipo_w ||' '|| vetor_conta_w[k].nr_nota ||' '|| Wheb_mensagem_pck.get_texto(798763) || ': ' || cd_brasindice_w, 
			vl_total_pago_w, 
			vl_cobrado_w, 
			vetor_conta_w[k].nr_interno_conta, 
			ie_gerar_resumo_w, 
			dt_execucao_w, 
			nr_seq_item_conta_w);
				 
		---RET_CONV_RATEAR_ITEM_IMP(nr_seq_movto_w,nr_interno_conta_w,'Tasy_Imp'); 
					 
	end loop;
	close C01;
 
	end;
end loop;
 
open C02;
loop 
fetch C02 into 
	nr_linha_w, 
	ie_tipo_w, 
	nr_doc_convenio_arq_w, 
	nr_nota_arq_w, 
	cd_usuario_conv_arq_w, 
	cd_item_w, 
	vl_total_pago_w, 
	vl_glosado_w, 
	vl_cobrado_w, 
	nm_paciente_w, 
	dia_ini_w, 
	valor_conta_arq_w, 
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	 
	if (substr(ie_tipo_w,1,2) = '00') then 
		valor_conta_w	:= (valor_conta_arq_w/100);
	end if;
	 
	if (substr(ie_tipo_w,1,2) = '00') then 
		begin 
		nr_nota_w		:= ltrim(nr_nota_arq_w,'0');
 
		/*select	max(a.nr_seq_protocolo) 
		into	nr_seq_protocolo_w 
		from	protocolo_convenio a 
		where	a.cd_convenio		= cd_convenio_w 
		and	a.ie_status_protocolo	= 2 
		and	exists 
			(select	1 
			from	conta_paciente x 
			where	x.nr_seq_protocolo	= a.nr_seq_protocolo 
			and	x.nr_conta_convenio	= nr_nota_w); 
		*/
	 
		end;
	else 
		begin 
 
		select	max(a.nr_seq_protocolo) 
		into STRICT	nr_seq_protocolo_w 
		from	protocolo_convenio a, 
			conta_paciente b, 
			atendimento_paciente c, 
			atend_categoria_convenio d 
		where	a.cd_convenio		= cd_convenio_w 
		and	a.nr_seq_protocolo	= b.nr_seq_protocolo 
		and	b.nr_atendimento	= c.nr_atendimento 
		and	c.nr_atendimento	= d.nr_atendimento 
		and	a.ie_status_protocolo	= 2 
		and	somente_numero(d.cd_usuario_convenio)	= cd_usuario_conv_arq_w	 
		and	exists (SELECT	1 
			from	conta_paciente x 
			where	x.nr_seq_protocolo	= a.nr_seq_protocolo 
			and	x.nr_conta_convenio	= nr_nota_w) 
		and (select	substr(x.dt_entrada,1,2) 
				from 	atendimento_paciente x 
				where	x.nr_atendimento = b.nr_atendimento ) = dia_ini_w;
			 
		if (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then 
			begin 
			 
			select	count(1) 
			into STRICT	qt_pcnc_w 
			from	protocolo_conv_nota_conta 
			where	nr_seq_protocolo = nr_seq_protocolo_w;
			 
			if (qt_pcnc_w = 0) then 
				begin 
				 
				select	max(a.nr_interno_conta) 
				into STRICT	nr_interno_conta_w 
				from	conta_paciente a, 
					atend_categoria_convenio b, 
					procedimento_paciente f 
				where	a.nr_atendimento	= b.nr_atendimento 
				and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
				and	a.nr_conta_convenio	= nr_nota_w 
				and	f.nr_interno_conta	= a.nr_interno_conta 
				and	coalesce(f.cd_procedimento_convenio,f.cd_procedimento) = cd_item_w 
				and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
				and	somente_numero(b.cd_usuario_convenio)	= cd_usuario_conv_arq_w 
				and	obter_saldo_conpaci(a.nr_interno_conta,null) <> 0 
				and (SELECT	substr(x.dt_entrada,1,2) 
				from 	atendimento_paciente x 
				where	x.nr_atendimento = a.nr_atendimento ) = dia_ini_w;
				 
				end;
			else 
				begin 
				 
				select	max(a.nr_interno_conta) 
				into STRICT	nr_interno_conta_w 
				from	protocolo_conv_nota_conta a, 
					conta_paciente b, 
					atend_categoria_convenio c, 
					procedimento_paciente f 
				where	a.nr_interno_conta	= b.nr_interno_conta 
				and	b.nr_atendimento	= c.nr_atendimento 
				and	c.nr_seq_interno	= obter_atecaco_atend_conv(b.nr_atendimento,cd_convenio_w) 
				and	f.nr_interno_conta	= a.nr_interno_conta 
				and	coalesce(f.cd_procedimento_convenio,f.cd_procedimento) = cd_item_w 
				and	somente_numero(c.cd_usuario_convenio)	= cd_usuario_conv_arq_w 
				and	obter_saldo_conpaci(b.nr_interno_conta,null) <> 0 
				and	a.nr_seq_protocolo = nr_seq_protocolo_w 
				and	a.nr_nota_conta	= nr_nota_w 
				and (SELECT	substr(x.dt_entrada,1,2) 
				from 	atendimento_paciente x 
				where	x.nr_atendimento = b.nr_atendimento ) = dia_ini_w;
				 
				end;
			end if;
 
			end;
		else 
			begin 
			 
			select	max(a.nr_interno_conta) 
			into STRICT	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b, 
				procedimento_paciente f 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	a.ie_status_acerto	= 2 
			and	(a.nr_seq_protocolo IS NOT NULL AND a.nr_seq_protocolo::text <> '') 
			and	f.nr_interno_conta	= a.nr_interno_conta 
			and	coalesce(f.cd_procedimento_convenio,f.cd_procedimento) = cd_item_w 
			and	a.cd_convenio_parametro	= cd_convenio_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	somente_numero(b.cd_usuario_convenio)	= cd_usuario_conv_arq_w 
			and	obter_saldo_conpaci(a.nr_interno_conta,null) <> 0 
			and (SELECT	substr(x.dt_entrada,1,2) 
				from 	atendimento_paciente x 
				where	x.nr_atendimento = a.nr_atendimento ) = dia_ini_w;
			 
			end;
		end if;
 
		vl_total_pago_w	:= dividir(coalesce(vl_total_pago_w,0),100);
		vl_glosado_w	:= dividir(coalesce(vl_glosado_w,0),100);
		vl_cobrado_w	:= dividir(coalesce(vl_cobrado_w,0),100);
 
		if	((nr_interno_conta_w = '') or 
			coalesce(nr_interno_conta_w::text, '') = '') then 
			 
			select	max(c.nr_seq_protocolo) 
			into STRICT	nr_seq_protocolo_ww 
			from	atendimento_paciente a, 
				atend_categoria_convenio b, 
				conta_paciente c, 
				procedimento_paciente f 
			where	a.nr_atendimento 	= b.nr_atendimento 
			and	a.nr_atendimento 	= c.nr_atendimento 
			and	f.nr_interno_conta	= c.nr_interno_conta 
			and	c.nr_conta_convenio	= nr_nota_w 
			and	somente_numero(b.cd_usuario_convenio) 	= cd_usuario_conv_arq_w 
			and	c.cd_convenio_parametro = cd_convenio_w 
			and (SELECT	substr(x.dt_entrada,1,2) 
				from 	atendimento_paciente x 
				where	x.nr_atendimento = a.nr_atendimento ) = dia_ini_w;
				 
			select	max(c.nr_seq_protocolo) 
			into STRICT	nr_seq_protocolo_ww 
			from	atendimento_paciente a, 
				atend_categoria_convenio b, 
				conta_paciente c, 
				procedimento_paciente f 
			where	a.nr_atendimento 	= b.nr_atendimento 
			and	a.nr_atendimento 	= c.nr_atendimento 
			and	f.nr_interno_conta	= c.nr_interno_conta 
			and	obter_valor_conta(c.nr_interno_conta,0) = valor_conta_w 
			and	somente_numero(b.cd_usuario_convenio) 	= cd_usuario_conv_arq_w 
			and	c.cd_convenio_parametro = cd_convenio_w 
			and (SELECT	substr(x.dt_entrada,1,2) 
				from 	atendimento_paciente x 
				where	x.nr_atendimento = a.nr_atendimento ) = dia_ini_w;
				 
			if (coalesce(nr_seq_protocolo_ww,0) = 0) then 
				select	max(c.nr_seq_protocolo) 
				into STRICT	nr_seq_protocolo_ww 
				from	atendimento_paciente a, 
					atend_categoria_convenio b, 
					conta_paciente c, 
					procedimento_paciente f 
				where	a.nr_atendimento 	= b.nr_atendimento 
				and	a.nr_atendimento 	= c.nr_atendimento 
				and	f.nr_interno_conta	= c.nr_interno_conta 
				and	somente_numero(b.cd_usuario_convenio) 	= cd_usuario_conv_arq_w 
				and	c.cd_convenio_parametro = cd_convenio_w 
				and (SELECT	substr(x.dt_entrada,1,2) 
					from 	atendimento_paciente x 
					where	x.nr_atendimento = a.nr_atendimento ) = dia_ini_w;
			end if;
					 
			select	max(c.nr_interno_conta) 
			into STRICT	nr_interno_conta_w 
			from	atendimento_paciente a, 
				atend_categoria_convenio b, 
				conta_paciente c, 
				procedimento_paciente f 
			where	a.nr_atendimento 	= b.nr_atendimento 
			and	a.nr_atendimento 	= c.nr_atendimento 
			and	f.nr_interno_conta	= c.nr_interno_conta 
			and	c.nr_seq_protocolo 	= nr_seq_protocolo_ww 
			and	coalesce(f.cd_procedimento_convenio,f.cd_procedimento) = cd_item_w 
			and	somente_numero(b.cd_usuario_convenio)	= cd_usuario_conv_arq_w 
			and	c.cd_convenio_parametro = cd_convenio_w 
			and (SELECT	substr(x.dt_entrada,1,2) 
				from 	atendimento_paciente x 
				where	x.nr_atendimento = a.nr_atendimento ) = dia_ini_w;
				 
		end if;
 
		if (substr(ie_tipo_w,3,2) = '76') then /*TR 76 não tem valor cobrado*/
 
			vl_cobrado_w	:= null;
		end if;
 
 
		insert into convenio_retorno_movto(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_retorno, 
			nr_doc_convenio, 
			cd_usuario_convenio, 
			cd_item, 
			vl_total_pago, 
			vl_glosa, 
			ds_complemento, 
			vl_pago, 
			vl_cobrado, 
			nr_conta) 
		values (nextval('convenio_retorno_movto_seq'), 
			clock_timestamp(), 
			'Tasy_Imp', 
			nr_seq_retorno_p, 
			nr_doc_convenio_w, 
			cd_usuario_conv_arq_w, 
			cd_item_w, 
			vl_total_pago_w, 
			vl_glosado_w, 
			'c02 TR '||ie_tipo_w||' '||nr_nota_w||' - '||nm_paciente_w, 
			vl_total_pago_w, 
			vl_cobrado_w, 
			nr_interno_conta_w);
		end;
 
	end if;
 
end loop;
close C02;
/* 
open C03; 
loop 
fetch C03 into 
	nr_linha_w, 
	ie_tipo_w, 
	nr_doc_convenio_arq_w, 
	nr_nota_arq_w, 
	cd_usuario_conv_arq_w, 
	cd_item_w, 
	vl_total_pago_w, 
	vl_glosado_w, 
	vl_cobrado_w, 
	nm_paciente_w; 
exit when C03%notfound; 
 
	if	(ie_tipo_w = '0076') then 
 
 
		nr_nota_w		:= ltrim(nr_nota_arq_w,'0'); 
		cd_usuario_conv_w	:= cd_usuario_conv_arq_w; 
 
 
		select	max(a.nr_seq_protocolo) 
		into	nr_seq_protocolo_w 
		from	protocolo_convenio a 
		where	a.cd_convenio		= cd_convenio_w 
		and	a.ie_status_protocolo	= 2 
		and	exists 
			(select	1 
			from	conta_paciente x 
			where	x.nr_seq_protocolo	= a.nr_seq_protocolo 
			and	x.nr_conta_convenio	= nr_nota_w); 
 
 
		if	(nr_seq_protocolo_w is not null) then 
 
 
			select	max(a.nr_interno_conta) 
			into	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	b.cd_usuario_convenio	= cd_usuario_conv_arq_w; 
 
 
		else 
 
 
			select	max(a.nr_interno_conta) 
			into	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	a.ie_status_acerto	= 2 
			and	a.nr_seq_protocolo	is not null 
			and	a.cd_convenio_parametro	= cd_convenio_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	b.cd_usuario_convenio	= cd_usuario_conv_arq_w; 
 
		end if; 
 
 
		vl_total_pago_w	:= dividir(nvl(vl_total_pago_w,0),100); 
		vl_glosado_w	:= dividir(nvl(vl_glosado_w,0),100); 
		vl_cobrado_w	:= 0; 
 
		if	(nr_interno_conta_w is not null) then 
 
 
			select	max(nr_sequencia), 
				nvl(max(vl_procedimento),0) 
			into	nr_seq_item_conta_w, 
				vl_cobrado_w 
			from	procedimento_paciente 
			where	nr_interno_conta		= nr_interno_conta_w 
			and	cd_motivo_exc_conta		is null 
			and	(cd_procedimento		= cd_item_w or 
				cd_procedimento_convenio	= cd_item_w or 
				cd_procedimento_tuss		= cd_item_w); 
 
 
			if	(nr_seq_item_conta_w is null) then 
 
 
				select	max(nr_sequencia), 
					nvl(max(vl_material),0) 
				into	nr_seq_item_conta_w, 
					vl_cobrado_w 
				from	material_atend_paciente 
				where	nr_interno_conta			= nr_interno_conta_w 
				and	cd_motivo_exc_conta			is null 
				and	(cd_material				= cd_item_w or 
					cd_material_convenio			= cd_item_w or 
 
					somente_numero(cd_material_tiss)	= cd_item_w); 
			end if; 
 
 
		end if; 
 
 
		insert into convenio_retorno_movto 
			(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_retorno, 
			nr_doc_convenio, 
			cd_usuario_convenio, 
			cd_item, 
			vl_total_pago, 
			vl_glosa, 
			ds_complemento, 
			vl_pago, 
			vl_cobrado, 
			nr_conta, 
			nr_seq_item_conta) 
		values	(convenio_retorno_movto_seq.nextval, 
			sysdate, 
			'Tasy_Imp', 
			nr_seq_retorno_p, 
			nr_doc_convenio_w, 
			cd_usuario_conv_w, 
			null,--cd_item_w, 
			vl_total_pago_w, 
			vl_glosado_w, 
			'c03 TR '||ie_tipo_w||' '||nr_nota_w||' - '||nm_paciente_w, 
			vl_total_pago_w, 
			vl_cobrado_w, 
			nr_interno_conta_w, 
			nr_seq_item_conta_w); 
 
	end if; 
 
 
end loop; 
close C03;*/
 
/* 
open C04; 
loop 
fetch C04 into 
	nr_linha_w, 
	ie_tipo_w, 
	nr_doc_convenio_arq_w, 
	nr_nota_arq_w, 
	cd_usuario_conv_arq_w, 
	cd_item_w, 
	vl_total_pago_w, 
	vl_glosado_w, 
	vl_cobrado_w, 
	nm_paciente_w; 
exit when C04%notfound; 
 
	if	(substr(ie_tipo_w,1,2) = '00') then 
 
 
		nr_nota_w		:= ltrim(nr_nota_arq_w,'0'); 
		cd_usuario_conv_w	:= cd_usuario_conv_arq_w; 
 
 
		select	max(a.nr_seq_protocolo) 
		into	nr_seq_protocolo_w 
		from	protocolo_convenio a 
		where	a.cd_convenio		= cd_convenio_w 
		and	a.ie_status_protocolo	= 2 
		and	exists 
			(select	1 
			from	conta_paciente x 
			where	x.nr_seq_protocolo	= a.nr_seq_protocolo 
			and	x.nr_conta_convenio	= nr_nota_w); 
 
 
		if	(nr_seq_protocolo_w is not null) then 
 
 
			select	max(a.nr_interno_conta) 
			into	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	b.cd_usuario_convenio	= cd_usuario_conv_arq_w 
			and	OBTER_SALDO_CONPACI(a.nr_interno_conta,null) <> 0; 
 
		else 
 
			select	max(a.nr_interno_conta) 
			into	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	a.ie_status_acerto	= 2 
			and	a.nr_seq_protocolo	is not null 
			and	a.cd_convenio_parametro	= cd_convenio_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	b.cd_usuario_convenio	= cd_usuario_conv_arq_w 
			and	OBTER_SALDO_CONPACI(a.nr_interno_conta,null) <> 0; 
 
		end if; 
 
		vl_total_pago_w	:= dividir(nvl(vl_total_pago_w,0),100); 
		vl_glosado_w	:= dividir(nvl(vl_glosado_w,0),100); 
		vl_cobrado_w	:= dividir(nvl(vl_cobrado_w,0),100); 
		 
		select	convenio_retorno_movto_seq.nextval 
		into	nr_seq_movto_w 
		from	dual;	 
 
 
		insert into convenio_retorno_movto 
			(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_retorno, 
			nr_doc_convenio, 
			cd_usuario_convenio, 
			cd_item, 
			vl_total_pago, 
			vl_glosa, 
			ds_complemento, 
			vl_pago, 
			vl_cobrado, 
			nr_conta) 
		values	(nr_seq_movto_w, 
			sysdate, 
			'Tasy_Imp', 
			nr_seq_retorno_p, 
			nr_doc_convenio_w, 
			cd_usuario_conv_w, 
			null, 
			vl_total_pago_w, 
			vl_glosado_w, 
			'c04 TR '||ie_tipo_w||' '||nr_nota_w||' - '||nm_paciente_w, 
			vl_total_pago_w, 
			vl_cobrado_w, 
			nr_interno_conta_w); 
			 
		RET_CONV_RATEAR_ITEM_IMP(nr_seq_movto_w,nr_interno_conta_w,'Tasy_Imp'); 
 
	end if; 
 
 
end loop; 
close C04; 
*/
 
/* 
open C05; 
loop 
fetch C05 into 
	nr_linha_w, 
	ie_tipo_w, 
	nr_doc_convenio_arq_w, 
	nr_nota_arq_w, 
	cd_usuario_conv_arq_w, 
	cd_item_w, 
	vl_total_pago_w, 
	vl_glosado_w, 
	vl_cobrado_w, 
	nm_paciente_w; 
exit when C05%notfound; 
 
	if	(ie_tipo_w = '0086') then 
 
 
		nr_nota_w		:= ltrim(nr_nota_arq_w,'0'); 
		cd_usuario_conv_w	:= cd_usuario_conv_arq_w; 
 
 
		select	max(a.nr_seq_protocolo) 
		into	nr_seq_protocolo_w 
		from	protocolo_convenio a 
		where	a.cd_convenio		= cd_convenio_w 
		and	a.ie_status_protocolo	= 2 
		and	exists 
			(select	1 
			from	conta_paciente x 
			where	x.nr_seq_protocolo	= a.nr_seq_protocolo 
			and	x.nr_conta_convenio	= nr_nota_w); 
 
 
		if	(nr_seq_protocolo_w is not null) then 
 
 
			select	max(a.nr_interno_conta) 
			into	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	b.cd_usuario_convenio	= cd_usuario_conv_arq_w; 
 
 
		else 
 
 
			select	max(a.nr_interno_conta) 
			into	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	a.ie_status_acerto	= 2 
			and	a.nr_seq_protocolo	is not null 
			and	a.cd_convenio_parametro	= cd_convenio_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	b.cd_usuario_convenio	= cd_usuario_conv_arq_w; 
 
		end if; 
 
 
 
		vl_total_pago_w	:= dividir(nvl(vl_total_pago_w,0),100); 
		vl_glosado_w	:= dividir(nvl(vl_glosado_w,0),100); 
		vl_cobrado_w	:= dividir(nvl(vl_cobrado_w,0),100); 
 
 
		insert into convenio_retorno_movto 
			(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_retorno, 
			nr_doc_convenio, 
			cd_usuario_convenio, 
			cd_item, 
			vl_total_pago, 
			vl_glosa, 
			ds_complemento, 
			vl_pago, 
			vl_cobrado, 
			nr_conta) 
		values	(convenio_retorno_movto_seq.nextval, 
			sysdate, 
			'Tasy_Imp', 
			nr_seq_retorno_p, 
			nr_doc_convenio_w, 
			cd_usuario_conv_w, 
			null, --cd_item_w, 
			vl_total_pago_w, 
			vl_glosado_w, 
			'c05 TR '||ie_tipo_w||' '||nr_nota_w||' - '||nm_paciente_w, 
			vl_total_pago_w, 
			vl_cobrado_w, 
			nr_interno_conta_w); 
 
	end if; 
 
 
end loop; 
close C05; 
 
/* 
open C06; 
loop 
fetch C06 into 
	nr_linha_w, 
	ie_tipo_w, 
	nr_doc_convenio_arq_w, 
	nr_nota_arq_w, 
	cd_usuario_conv_arq_w, 
	cd_item_w, 
	vl_total_pago_w, 
	vl_glosado_w, 
	vl_cobrado_w, 
	nm_paciente_w; 
exit when C06%notfound; 
 
	if	(ie_tipo_w = '0077') then 
 
 
		nr_nota_w		:= ltrim(nr_nota_arq_w,'0'); 
		cd_usuario_conv_w	:= cd_usuario_conv_arq_w; 
 
 
		select	max(a.nr_seq_protocolo) 
		into	nr_seq_protocolo_w 
		from	protocolo_convenio a 
		where	a.cd_convenio		= cd_convenio_w 
		and	a.ie_status_protocolo	= 2 
		and	exists 
			(select	1 
			from	conta_paciente x 
			where	x.nr_seq_protocolo	= a.nr_seq_protocolo 
			and	x.nr_conta_convenio	= nr_nota_w); 
 
 
		if	(nr_seq_protocolo_w is not null) then 
 
 
			select	max(a.nr_interno_conta) 
			into	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	a.nr_seq_protocolo	= nr_seq_protocolo_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	b.cd_usuario_convenio	= cd_usuario_conv_arq_w; 
 
 
		else 
 
 
			select	max(a.nr_interno_conta) 
			into	nr_interno_conta_w 
			from	conta_paciente a, 
				atend_categoria_convenio b 
			where	a.nr_atendimento	= b.nr_atendimento 
			and	b.nr_seq_interno	= obter_atecaco_atend_conv(a.nr_atendimento,cd_convenio_w) 
			and	a.ie_status_acerto	= 2 
			and	a.nr_seq_protocolo	is not null 
			and	a.cd_convenio_parametro	= cd_convenio_w 
			and	a.nr_conta_convenio	= nr_nota_w 
			and	b.cd_usuario_convenio	= cd_usuario_conv_arq_w; 
 
		end if; 
 
		vl_total_pago_w	:= dividir(nvl(vl_total_pago_w,0),100); 
		vl_glosado_w	:= dividir(nvl(vl_glosado_w,0),100); 
		vl_cobrado_w	:= dividir(nvl(vl_cobrado_w,0),100); 
 
 
		insert into convenio_retorno_movto 
			(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_retorno, 
			nr_doc_convenio, 
			cd_usuario_convenio, 
			cd_item, 
			vl_total_pago, 
			vl_glosa, 
			ds_complemento, 
			vl_pago, 
			vl_cobrado, 
			nr_conta) 
		values	(convenio_retorno_movto_seq.nextval, 
			sysdate, 
			'Tasy_Imp', 
			nr_seq_retorno_p, 
			nr_doc_convenio_w, 
			cd_usuario_conv_w, 
			null, 
			vl_total_pago_w, 
			vl_glosado_w, 
			'c06 TR '||ie_tipo_w||' '||nr_nota_w||' - '||nm_paciente_w, 
			vl_total_pago_w, 
			vl_cobrado_w, 
			nr_interno_conta_w); 
 
	end if; 
 
 
end loop; 
close C06;*/
 
 
/*commit; 
 
open C07; 
loop 
fetch C07 into	 
	cd_user_conv_w; 
exit when C07%notfound; 
		begin 
		 
		select	max(nr_conta) 
		into	nr_interno_conta_w 
		from	convenio_retorno_movto 
		where	nr_seq_retorno = nr_seq_retorno_p 
		and	cd_usuario_convenio = cd_user_conv_w 
		and	nr_conta > 0; 
		 
		update	convenio_retorno_movto 
		set	nr_conta = nr_interno_conta_w 
		where	nr_seq_retorno = nr_seq_retorno_p 
		and	cd_usuario_convenio = cd_user_conv_w 
		and	((nr_conta = '') or (nr_conta is null)); 
		 
		end; 
end loop; 
close C07;		 
*/
 
 
delete	from	w_conv_ret_movto 
where	nr_seq_retorno	= nr_seq_retorno_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ipe_gerar_convenio_ret_movto_w (nr_seq_retorno_p bigint) FROM PUBLIC;
