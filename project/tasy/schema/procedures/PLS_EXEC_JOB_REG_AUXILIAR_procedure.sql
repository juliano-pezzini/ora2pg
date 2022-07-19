-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_exec_job_reg_auxiliar ( nr_seq_reg_auxiliar_p bigint) AS $body$
DECLARE


jobno			        bigint;
ds_comando_job_w	        varchar(2000);
nm_usuario_w		        usuario.nm_usuario%type;
cd_estabelecimento_w	        estabelecimento.cd_estabelecimento%type;
dt_geracao_w                    ctb_livro_auxiliar.dt_geracao%type;
dt_inicial_w                    ctb_livro_auxiliar.dt_inicial%type;
dt_final_w                      ctb_livro_auxiliar.dt_final%type;
ie_tipo_reg_auxiliar_ans_w      ctb_livro_auxiliar.ie_tipo_reg_auxiliar_ans%type;
cd_estab_exclusivo_w            ctb_livro_auxiliar.cd_estab_exclusivo%type;
ie_tipo_protocolo_w             ctb_livro_auxiliar.ie_tipo_protocolo%type;
ie_tipo_segurado_w              ctb_livro_auxiliar.ie_tipo_segurado%type;
ie_recurso_proprio_w            ctb_livro_auxiliar.ie_recurso_proprio%type;
ie_copartic_faturar_w           ctb_livro_auxiliar.ie_copartic_faturar%type;
ie_status_mensalidade_w         ctb_livro_auxiliar.ie_status_mensalidade%type;
ie_classificacao_w              ctb_livro_auxiliar.ie_classificacao%type;

C01 CURSOR FOR
	-- falhas is not null, significa que já foi executado pelo menos uma vez, se já foi executado ao menos uma vez, apaga. durante a execução ele fica null
	SELECT	job
	from	job_v
	where	comando	like 'pls_gerar_registro_auxiliar%'
	and	(falhas IS NOT NULL AND falhas::text <> '');

BEGIN
select  dt_inicial,
        dt_final,
        ie_tipo_reg_auxiliar_ans,
        cd_estab_exclusivo,
        ie_tipo_protocolo,
        ie_tipo_segurado,
        ie_recurso_proprio,
        ie_copartic_faturar,
        ie_status_mensalidade,
        ie_classificacao
into STRICT    dt_inicial_w,
        dt_final_w,
        ie_tipo_reg_auxiliar_ans_w,
        cd_estab_exclusivo_w,
        ie_tipo_protocolo_w,
        ie_tipo_segurado_w,
        ie_recurso_proprio_w,
        ie_copartic_faturar_w,
        ie_status_mensalidade_w,
        ie_classificacao_w
from    ctb_livro_auxiliar
where   nr_sequencia = nr_seq_reg_auxiliar_p;

select  max(a.dt_geracao)
into STRICT    dt_geracao_w
from    ctb_livro_auxiliar a
where   a.nr_sequencia <> nr_seq_reg_auxiliar_p
and (dt_inicial_w between a.dt_inicial and a.dt_final
or	dt_final_w between a.dt_inicial and a.dt_final)
and	a.ie_tipo_reg_auxiliar_ans = ie_tipo_reg_auxiliar_ans_w
and 	((a.cd_estab_exclusivo = cd_estab_exclusivo_w)
        or (coalesce(cd_estab_exclusivo_w::text, '') = ''))
and 	((a.ie_tipo_protocolo = ie_tipo_protocolo_w)
        or (coalesce(ie_tipo_protocolo_w::text, '') = ''))
and 	((a.ie_tipo_segurado = ie_tipo_segurado_w)
        or (coalesce(ie_tipo_segurado_w::text, '') = ''))
and 	((a.ie_recurso_proprio = ie_recurso_proprio_w)
        or (coalesce(ie_recurso_proprio_w::text, '') = ''))
and 	((a.ie_copartic_faturar = ie_copartic_faturar_w)
        or (coalesce(ie_copartic_faturar_w::text, '') = ''))
and 	((a.ie_status_mensalidade = ie_status_mensalidade_w)
        or (coalesce(ie_status_mensalidade_w::text, '') = ''))
and 	((a.ie_classificacao = ie_classificacao_w)
        or (coalesce(ie_classificacao_w::text, '') = ''));

if (dt_geracao_w IS NOT NULL AND dt_geracao_w::text <> '') then
        CALL wheb_mensagem_pck.exibir_mensagem_abort(432990);
end if;


-- Verificar se a job já existe, se existir remove
for r_C01_w in C01 loop
	dbms_job.remove(r_C01_w.job);
	commit;
end loop;

-- Alteração de status para Aguardando processamento
update	ctb_livro_auxiliar
set	ie_status = '2'
where	nr_sequencia = nr_seq_reg_auxiliar_p;

commit;

nm_usuario_w		:= wheb_usuario_pck.get_nm_usuario;
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;

ds_comando_job_w	:= 'pls_gerar_registro_auxiliar(' || nr_seq_reg_auxiliar_p || ','
							|| pls_util_pck.aspas_w || 'G' || pls_util_pck.aspas_w || ','
							|| pls_util_pck.aspas_w || nm_usuario_w || pls_util_pck.aspas_w
							|| ',' || cd_estabelecimento_w || ');';

-- Vai iniciar a procedure em 2.5 segundos após a conclusão desta e sempre joga a próxima execução para daqui a 99999 dias
dbms_job.submit(jobno, ds_comando_job_w, clock_timestamp() + interval '216000 seconds' * (1/24/60/60), 'sysdate + 99999');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_exec_job_reg_auxiliar ( nr_seq_reg_auxiliar_p bigint) FROM PUBLIC;

