-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_item_glosado_rep ( nr_seq_ret_item_p bigint, nr_seq_proc_rep_p bigint, nr_seq_mat_rep_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
insert	into convenio_retorno_glosa(cd_material, 
	cd_pessoa_fisica, 
	cd_procedimento, 
	cd_setor_atendimento, 
	cd_setor_responsavel, 
	ds_observacao, 
	dt_atualizacao, 
	ie_atualizacao, 
	ie_origem_proced, 
	nm_usuario, 
	nr_seq_matpaci, 
	nr_seq_propaci, 
	nr_seq_ret_item, 
	nr_sequencia, 
	qt_glosa, 
	vl_glosa, 
	vl_amaior, 
	vl_cobrado, 
	qt_cobrada) 
SELECT	cd_material, 
	cd_pessoa_fisica, 
	cd_procedimento, 
	cd_setor_atendimento, 
	cd_setor_responsavel, 
	ds_observacao, 
	dt_atualizacao, 
	ie_atualizacao, 
	ie_origem_proced, 
	nm_usuario, 
	nr_seq_matpaci, 
	nr_seq_propaci, 
	nr_seq_ret_item, 
	nextval('convenio_retorno_glosa_seq'), 
	qt_procedimento, 
	vl_glosa, 
	vl_amaior, 
	vl_cobrado, 
	qt_cobrada 
from (SELECT	null cd_material, 
	b.cd_pessoa_fisica, 
	b.cd_procedimento, 
	b.cd_setor_atendimento, 
	b.cd_setor_atendimento cd_setor_responsavel, 
	Wheb_mensagem_pck.get_Texto(306807) ds_observacao, /*'Item gerado a partir do repasse pendente.'*/
 
	clock_timestamp() dt_atualizacao, 
	'N' ie_atualizacao, 
	b.ie_origem_proced, 
	nm_usuario_p nm_usuario, 
	null nr_seq_matpaci, 
	b.nr_sequencia nr_seq_propaci, 
	nr_seq_ret_item_p nr_seq_ret_item, 
	b.qt_procedimento, 
	coalesce(a.vl_repasse,0) - coalesce(a.vl_liberado,0) vl_glosa, 
	0 vl_amaior, 
	b.vl_procedimento vl_cobrado, 
	b.qt_procedimento qt_cobrada 
from	procedimento_paciente b, 
	procedimento_repasse a 
where	(nr_seq_proc_rep_p IS NOT NULL AND nr_seq_proc_rep_p::text <> '') 
and	a.nr_sequencia		= nr_seq_proc_rep_p 
and	a.nr_seq_procedimento	= b.nr_sequencia 
and	coalesce(a.vl_liberado,0) 	<= coalesce(a.vl_repasse,0) 

union
 
select	null cd_material, 
	b.cd_pessoa_fisica, 
	b.cd_procedimento, 
	b.cd_setor_atendimento, 
	b.cd_setor_atendimento, 
	Wheb_mensagem_pck.get_Texto(306807), /*'Item gerado a partir do repasse pendente.'*/
 
	clock_timestamp(), 
	'N', 
	b.ie_origem_proced, 
	nm_usuario_p, 
	null, 
	b.nr_sequencia, 
	nr_seq_ret_item_p, 
	b.qt_procedimento, 
	0, 
	coalesce(a.vl_liberado,0) - coalesce(a.vl_repasse,0), 
	b.vl_procedimento vl_cobrado, 
	b.qt_procedimento qt_cobrada 
from	procedimento_paciente b, 
	procedimento_repasse a 
where	(nr_seq_proc_rep_p IS NOT NULL AND nr_seq_proc_rep_p::text <> '') 
and	a.nr_sequencia		= nr_seq_proc_rep_p 
and	a.nr_seq_procedimento	= b.nr_sequencia 
and	coalesce(a.vl_liberado,0) 	> coalesce(a.vl_repasse,0) 

union
 
select	b.cd_material, 
	c.cd_pessoa_fisica, 
	null, 
	b.cd_setor_atendimento, 
	b.cd_setor_atendimento, 
	Wheb_mensagem_pck.get_Texto(306807), /*'Item gerado a partir do repasse pendente.'*/
 
	clock_timestamp(), 
	'N', 
	null, 
	nm_usuario_p, 
	b.nr_sequencia, 
	null, 
	nr_seq_ret_item_p, 
	b.qt_material, 
	coalesce(a.vl_repasse,0) - coalesce(a.vl_liberado,0), 
	0, 
	b.vl_material vl_cobrado, 
	b.qt_material qt_cobrada 
from	atendimento_paciente c, 
	material_atend_paciente b, 
	material_repasse a 
where	(nr_seq_mat_rep_p IS NOT NULL AND nr_seq_mat_rep_p::text <> '') 
and	a.nr_sequencia		= nr_seq_mat_rep_p 
and	a.nr_seq_material	= b.nr_sequencia 
and	b.nr_atendimento	= c.nr_atendimento 
and	coalesce(a.vl_liberado,0) 	<= coalesce(a.vl_repasse,0) 

union
 
select	b.cd_material, 
	c.cd_pessoa_fisica, 
	null, 
	b.cd_setor_atendimento, 
	b.cd_setor_atendimento, 
	Wheb_mensagem_pck.get_Texto(306807), /*'Item gerado a partir do repasse pendente.'*/
 
	clock_timestamp(), 
	'N', 
	null, 
	nm_usuario_p, 
	b.nr_sequencia, 
	null, 
	nr_seq_ret_item_p, 
	b.qt_material, 
	0, 
	coalesce(a.vl_liberado,0) - coalesce(a.vl_repasse,0), 
	b.vl_material vl_cobrado, 
	b.qt_material qt_cobrada 
from	atendimento_paciente c, 
	material_atend_paciente b, 
	material_repasse a 
where	(nr_seq_mat_rep_p IS NOT NULL AND nr_seq_mat_rep_p::text <> '') 
and	a.nr_sequencia		= nr_seq_mat_rep_p 
and	a.nr_seq_material	= b.nr_sequencia 
and	b.nr_atendimento	= c.nr_atendimento 
and	coalesce(a.vl_liberado,0) 	< coalesce(a.vl_repasse,0)) alias30;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_item_glosado_rep ( nr_seq_ret_item_p bigint, nr_seq_proc_rep_p bigint, nr_seq_mat_rep_p bigint, nm_usuario_p text) FROM PUBLIC;
