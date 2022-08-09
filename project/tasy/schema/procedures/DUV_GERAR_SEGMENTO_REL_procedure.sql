-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duv_gerar_segmento_rel ( nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) AS $body$
DECLARE


/*
ie_tipo_tabela
1 = GOÄ-Nr.
2 = Leit-Nr. (Ärzteabkom.)
3 = Sonstige (z.B. Fahrgeld)
*/
c01 CURSOR FOR
SELECT	a.dt_procedimento dt_fatura,
	a.vl_procedimento vl_taxas,
	p.cd_procedimento_loc cd_item,
	CASE WHEN a.ie_origem_proced='9' THEN '1'  ELSE '3' END  ie_tipo_tabela,
	0 vl_outros,
	null vl_total_conta,
	null vl_materiais,
	substr(a.ds_indicacao,1,100) ds_observacao
from	procedimento_paciente a,
	atendimento_paciente b,
	conta_paciente c,
	procedimento p
where	a.cd_procedimento	= p.cd_procedimento
and	a.ie_origem_proced	= p.ie_origem_proced
and	a.nr_interno_conta	= c.nr_interno_conta
and	c.nr_atendimento	= b.nr_atendimento
and	c.ie_status_acerto	= '2'
and	b.nr_seq_episodio	= nr_seq_episodio_p;

c01_w c01%rowtype;


BEGIN

c01_w := null;
open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	insert into duv_rel(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_mensagem,
		dt_fatura,
		vl_taxas,
		cd_item,
		ie_tipo_tabela,
		vl_outros,
		vl_total_conta,
		vl_materiais,
		ds_observacao)
	values (nextval('duv_rel_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_mensagem_p,
		c01_w.dt_fatura,
		c01_w.vl_taxas,
		c01_w.cd_item,
		c01_w.ie_tipo_tabela,
		c01_w.vl_outros,
		c01_w.vl_total_conta,
		c01_w.vl_materiais,
		c01_w.ds_observacao);
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duv_gerar_segmento_rel ( nr_seq_mensagem_p duv_mensagem.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;
