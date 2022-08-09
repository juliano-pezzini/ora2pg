-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_valor_faturar_fagf (ie_identificacao_aih_p bigint, ie_complexidade_p text, ie_status_protocolo_p bigint, dt_referencia_p text, nr_seq_protocolo_p text, cd_especialidade_aih_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_interno_conta_w		bigint;
ds_complexidade_w		varchar(255);
qt_aih_w			bigint;
cd_especialidade_aih_w		smallint;
ie_complexidade_w		varchar(2);
qt_procedimento_w		double precision;
vl_sem_uti_w			double precision;
qt_uti_w			bigint;
vl_uti_w			double precision;
vl_aih_uti_w			double precision;

C01 CURSOR FOR 
	SELECT	c.nr_interno_conta 
	FROM protocolo_convenio l, conta_paciente c
LEFT OUTER JOIN sus_aih_unif h ON (c.nr_interno_conta = h.nr_interno_conta)
WHERE l.nr_seq_protocolo = c.nr_seq_protocolo and (h.ie_complexidade IS NOT NULL AND h.ie_complexidade::text <> '') and ((h.ie_identificacao_aih = coalesce(ie_identificacao_aih_p,0)) or (coalesce(ie_identificacao_aih_p,0) = 0)) and ((h.ie_complexidade = coalesce(ie_complexidade_p,'0')) or (coalesce(ie_complexidade_p,'0') = '0')) and ((l.ie_status_protocolo = coalesce(ie_status_protocolo_p,0)) or (coalesce(ie_status_protocolo_p,0) = 0)) AND to_char(l.dt_mesano_referencia,'yyyymm') = dt_referencia_p and ((l.nr_seq_protocolo = coalesce(nr_seq_protocolo_p,'0')) or (coalesce(nr_seq_protocolo_p,'0') = '0')) and ((h.cd_especialidade_aih = coalesce(cd_especialidade_aih_p,0)) or (coalesce(cd_especialidade_aih_p,0) = 0)) order by	c.nr_interno_conta;
	

BEGIN 
 
delete from w_sus_prev_valores_fagf where nm_usuario = nm_usuario_p;
 
commit;
 
open C01;
loop 
fetch C01 into	 
	nr_interno_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	substr(obter_valor_dominio(1763,h.ie_complexidade),1,200) || ' - ' ||substr(obter_valor_dominio(1710, l.ie_status_protocolo),1,150), 
		(CASE WHEN count(h.nr_aih)=0 THEN null  ELSE count(h.nr_aih) END )::numeric , 
		h.cd_especialidade_aih, 
		h.ie_complexidade 
	into STRICT	ds_complexidade_w, 
		qt_aih_w, 
		cd_especialidade_aih_w, 
		ie_complexidade_w 
	FROM protocolo_convenio l, conta_paciente c
LEFT OUTER JOIN sus_aih_unif h ON (c.nr_interno_conta = h.nr_interno_conta)
WHERE l.nr_seq_protocolo = c.nr_seq_protocolo and c.nr_interno_conta = nr_interno_conta_w group by h.ie_complexidade, l.ie_status_protocolo, h.cd_especialidade_aih;
	 
	select	coalesce(sum(w.qt_procedimento),0) 
	into STRICT	qt_procedimento_w 
	from	conta_paciente c, 
		procedimento_paciente w 
	where	w.nr_interno_conta = c.nr_interno_conta 
	and	coalesce(w.cd_motivo_exc_conta::text, '') = '' 
	and	w.cd_procedimento = 802010083 
	and	c.nr_interno_conta = nr_interno_conta_w;
	 
	select	coalesce(sum(coalesce(y.vl_sadt,0)) + 
		sum(coalesce(w.vl_medico,0)) + 
		sum(coalesce(y.vl_matmed,0)) + 
		sum(coalesce(Obter_Valor_Participante(w.nr_sequencia),0)),0) 
	into STRICT	vl_sem_uti_w 
	from	conta_paciente c, 
		procedimento_paciente w, 
		sus_valor_proc_paciente y 
	where	w.nr_interno_conta = c.nr_interno_conta 
	and	y.nr_sequencia = w.nr_sequencia 
	and	coalesce(w.cd_motivo_exc_conta::text, '') = '' 
	and	w.cd_procedimento <> 802010083 
	and	c.nr_interno_conta = nr_interno_conta_w;
	 
	select	count(distinct s.nr_aih) 
	into STRICT	qt_uti_w 
	FROM procedimento_paciente w, conta_paciente c
LEFT OUTER JOIN sus_aih_unif s ON (c.nr_interno_conta = s.nr_interno_conta)
WHERE w.nr_interno_conta = c.nr_interno_conta and coalesce(w.cd_motivo_exc_conta::text, '') = '' and w.cd_procedimento = 802010083 and c.nr_interno_conta = nr_interno_conta_w;
	 
	select	coalesce(sum(coalesce(y.vl_sadt,0)) + 
		sum(coalesce(w.vl_medico,0)) + 
		sum(coalesce(y.vl_matmed,0)) + 
		sum(coalesce(Obter_Valor_Participante(w.nr_sequencia),0)),0) 
	into STRICT	vl_uti_w 
	from	conta_paciente c, 
		procedimento_paciente w, 
		sus_valor_proc_paciente y 
	where	w.nr_interno_conta = c.nr_interno_conta 
	and	y.nr_sequencia = w.nr_sequencia 
	and	coalesce(w.cd_motivo_exc_conta::text, '') = '' 
	and	w.cd_procedimento = 802010083 
	and	c.nr_interno_conta = nr_interno_conta_w;
	 
	select	sum(coalesce(y.vl_sadt,0)) + 
		sum(coalesce(w.vl_medico,0)) + 
		sum(coalesce(y.vl_matmed,0)) + 
		sum(coalesce(Obter_Valor_Participante(w.nr_sequencia),0)) 
	into STRICT	vl_aih_uti_w 
	from	conta_paciente c, 
		procedimento_paciente w, 
		sus_valor_proc_paciente y 
	where	w.nr_interno_conta = c.nr_interno_conta 
	and	y.nr_sequencia = w.nr_sequencia 
	and	coalesce(w.cd_motivo_exc_conta::text, '') = '' 
	and	c.nr_interno_conta = nr_interno_conta_w;
	 
	insert into w_sus_prev_valores_fagf( 
					nr_sequencia, 
					nr_interno_conta, 
					ds_complexidade, 
					qt_aih, 
					cd_especialidade_aih, 
					ie_complexidade, 
					qt_procedimento, 
					vl_sem_uti, 
					qt_uti, 
					vl_uti, 
					vl_aih_uti, 
					nm_usuario, 
					dt_atualizacao, 
					nm_usuario_nrec, 
					dt_atualizacao_nrec) 
				values (	nextval('w_sus_prev_valores_fagf_seq'), 
					nr_interno_conta_w, 
					ds_complexidade_w, 
					qt_aih_w, 
					cd_especialidade_aih_w, 
					ie_complexidade_w, 
					qt_procedimento_w, 
					vl_sem_uti_w, 
					qt_uti_w, 
					vl_uti_w, 
					vl_aih_uti_w, 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp());
	end;
end loop;
close C01;	
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_valor_faturar_fagf (ie_identificacao_aih_p bigint, ie_complexidade_p text, ie_status_protocolo_p bigint, dt_referencia_p text, nr_seq_protocolo_p text, cd_especialidade_aih_p bigint, nm_usuario_p text) FROM PUBLIC;
