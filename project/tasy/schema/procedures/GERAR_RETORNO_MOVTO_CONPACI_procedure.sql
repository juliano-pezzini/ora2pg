-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_movto_conpaci (nr_seq_ret_item_p bigint, ie_gerar_valor_pago_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_retorno_w		bigint;
nr_interno_conta_w		bigint;
cd_autorizacao_w		varchar(255);
qt_movto_w			bigint;
cd_setor_atendimento_w		bigint;
dt_item_w			timestamp;
hr_item_w			bigint;
cd_item_convenio_w		varchar(255);
qt_item_w			double precision;
vl_item_w			double precision;
vl_pago_w			double precision;
vl_total_pago_w			double precision;
qt_paga_w			double precision;
ds_item_w			varchar(240);

c01 CURSOR FOR 
	SELECT	a.ds_item, 
		a.cd_setor_atendimento, 
		somente_numero(coalesce(a.cd_item_convenio, a.cd_item)), 
		trunc(a.dt_conta,'dd'), 
		somente_numero(to_char(a.dt_conta,'hh24mi')), 
		sum(coalesce(a.qt_item,0) - coalesce(b.qt_paga,0)), 
		sum(coalesce(a.vl_item,0) - coalesce(b.vl_pago,0)) 
	FROM trunc(a, somente_numero(to_char(a, somente_numero(coalesce(a, conta_paciente_v a
LEFT OUTER JOIN (SELECT	cd_setor_atendimento, 
				cd_item, 
				dt_execucao, 
				hr_execucao, 
				coalesce(sum(qt_paga),0) qt_paga, 
				coalesce(sum(vl_total_pago),0) vl_pago 
		from convenio_retorno_movto 
		where nr_seq_retorno  <> nr_seq_retorno_w 
		 and nr_conta     = nr_interno_conta_w 
		 and nr_doc_convenio  = cd_autorizacao_w 
		group by	cd_setor_atendimento, 
				cd_item, 
				dt_execucao, 
				hr_execucao) b ON (a.cd_setor_atendimento = b.cd_setor_atendimento)
WHERE a.nr_interno_conta = nr_interno_conta_w and coalesce(a.nr_doc_convenio, cd_autorizacao_w) = cd_autorizacao_w     and coalesce(a.ie_cancelamento::text, '') = '' and coalesce(a.cd_motivo_exc_conta::text, '') = '' group by    a.cd_setor_atendimento, a.ds_item, 
	        somente_numero(coalesce(a.cd_item_convenio, a.cd_item)), 
	        trunc(a.dt_conta,'dd'), 
	        somente_numero(to_char(a.dt_conta,'hh24mi')) 
	having(sum(coalesce(a.qt_item,0) - coalesce(b.qt_paga,0))) > 0 
	  and (sum(coalesce(a.vl_item,0) - coalesce(b.vl_pago,0))) > 0;


BEGIN 
 
select nr_seq_retorno, 
	 nr_interno_conta, 
	 cd_autorizacao 
into STRICT	nr_seq_retorno_w, 
	nr_interno_conta_w, 
	cd_autorizacao_w 
from convenio_retorno_item 
where nr_sequencia = nr_seq_ret_item_p;
 
select count(*) 
into STRICT	qt_movto_w 
from convenio_retorno_movto 
where nr_seq_ret_item = nr_seq_ret_item_p;
 
if (qt_movto_w = 0) then 
	open c01;
	loop 
	fetch c01 into 
		ds_item_w, 
		cd_setor_atendimento_w, 
		cd_item_convenio_w, 
		dt_item_w, 
		hr_item_w, 
		qt_item_w, 
		vl_item_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		vl_pago_w		:= 0;
		qt_paga_w		:= 0;
		vl_total_pago_w	:= 0;
		if (ie_gerar_valor_pago_p = 'S') then 
			vl_pago_w		:= dividir(vl_item_w, qt_item_w);
			qt_paga_w		:= qt_item_w;
			vl_total_pago_w	:= vl_item_w;
		end if;
 
		insert into convenio_retorno_movto(nr_sequencia, 
			nr_seq_retorno, 
			nr_seq_ret_item, 
			nr_doc_convenio, 
			nr_conta, 
			cd_setor_atendimento, 
			cd_item, 
			qt_cobrada, 
			vl_cobrado, 
			qt_paga, 
			vl_pago, 
			dt_execucao, 
			hr_execucao, 
			dt_atualizacao, 
			nm_usuario, 
			ie_gera_resumo, 
			vl_total_pago, 
			ds_item_retorno) 
		values (nextval('convenio_retorno_movto_seq'), 
			nr_seq_retorno_w, 
			nr_seq_ret_item_p, 
			cd_autorizacao_w, 
			nr_interno_conta_w, 
			cd_setor_atendimento_w, 
			cd_item_convenio_w, 
			qt_item_w, 
			vl_item_w, 
			qt_paga_w, 
			vl_pago_w, 
			dt_item_w, 
			hr_item_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			'U', 
			vl_total_pago_w, 
			ds_item_w);
	end loop;
	close c01;
 
	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_movto_conpaci (nr_seq_ret_item_p bigint, ie_gerar_valor_pago_p text, nm_usuario_p text) FROM PUBLIC;

