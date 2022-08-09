-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_se_exc_franq_pag (nr_seq_regra_p pls_regra_franq_pag.nr_sequencia%type, cd_medico_p medico.cd_pessoa_fisica%type, ie_excessao_p INOUT text, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


c01 CURSOR(nr_seq_regra_cp	pls_regra_franq_pag.nr_sequencia%type) FOR
SELECT	cd_medico
from	pls_regra_franq_pag_exc
where	((cd_medico	= cd_medico_p) or (coalesce(cd_medico::text, '') = ''))
and	nr_seq_regra	= nr_seq_regra_cp
order 	by cd_medico;

BEGIN
ie_excessao_p		:= 'N';

for	r_c01_w	in c01(nr_seq_regra_p) loop
	ie_excessao_p	:= 'S';
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_se_exc_franq_pag (nr_seq_regra_p pls_regra_franq_pag.nr_sequencia%type, cd_medico_p medico.cd_pessoa_fisica%type, ie_excessao_p INOUT text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
