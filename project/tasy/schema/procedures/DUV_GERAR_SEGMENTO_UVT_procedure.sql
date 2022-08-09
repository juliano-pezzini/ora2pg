-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_uvt (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


c01 CURSOR FOR
SELECT 	substr(cv.ds_convenio,1,140) as ds_convenio,
	pj.cd_cnes  cd_convenio_ext,
	clock_timestamp() dt_relatorio,
	ap.dt_ocorrencia dt_acidente,
	null nr_arquivo
from  	atendimento_paciente	ap,
	episodio_paciente       ep,
	conta_paciente          cp,
	pessoa_juridica         pj,
	convenio                cv
where 	ap.nr_seq_episodio        = ep.nr_sequencia
and   	ap.nr_seq_episodio        = nr_seq_episodio_p
and   	ap.nr_atendimento         = cp.nr_atendimento
and   	cp.cd_convenio_parametro  = cv.cd_convenio
and   	cv.cd_cgc                 = pj.cd_cgc;

c01_w c01%rowtype;


BEGIN
c01_w := null;
open c01;
fetch c01 into c01_w;
close c01;

insert into duv_uvt(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_mensagem,
	ds_convenio,
	cd_convenio_ext,
	dt_relatorio,
	dt_acidente,
	nr_arquivo)
values (nextval('duv_uvt_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_mensagem_p,
	c01_w.ds_convenio,
	c01_w.cd_convenio_ext,
	c01_w.dt_relatorio,
	c01_w.dt_acidente,
	c01_w.nr_arquivo);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_uvt (nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;
