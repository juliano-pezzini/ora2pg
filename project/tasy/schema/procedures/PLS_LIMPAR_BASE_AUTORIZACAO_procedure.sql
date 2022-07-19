-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_limpar_base_autorizacao ( nr_seq_autorizacao_p bigint) AS $body$
DECLARE


nr_seq_glosa_guia_w	bigint;
nr_seq_auditoria_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_guia_glosa
	where	nr_seq_guia		= nr_seq_autorizacao_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_auditoria
	where	nr_seq_guia = nr_seq_autorizacao_p;




BEGIN

open C01;
loop
fetch C01 into
	nr_seq_glosa_guia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	delete	FROM PLS_OCORRENCIA_BENEF
	where	nr_seq_glosa_guia	= nr_seq_glosa_guia_w;

	end;
end loop;
close C01;

open c02;
loop
fetch c02 into
	nr_seq_auditoria_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin

	delete	FROM pls_auditoria_item
	where	nr_seq_auditoria	= nr_seq_auditoria_w;

	delete	FROM pls_auditoria_grupo
	where	nr_seq_auditoria	= nr_seq_auditoria_w;

	delete	FROM pls_auditoria_anexo
	where	nr_seq_auditoria	= nr_seq_auditoria_w;

	end;
end loop;
close c02;

delete	FROM pls_auditoria
where	nr_seq_guia = nr_seq_autorizacao_p;

/*PLS_GUIA_GLOSA*/

delete	from	pls_guia_glosa
	where	nr_seq_guia		= nr_seq_autorizacao_p;

delete	from	pls_guia_glosa
	where	nr_seq_guia_proc	= nr_seq_autorizacao_p;

delete	from	pls_guia_glosa
	where	nr_seq_guia_mat		= nr_seq_autorizacao_p;
/*PLS_GUIA_CONTA_AUTOR*/

delete	from	pls_conta_autor
	where	nr_seq_autor		= nr_seq_autorizacao_p;

delete	from	pls_conta_autor
	where	nr_seq_autor_proc	= nr_seq_autorizacao_p;

delete	from	pls_conta_autor
	where	nr_seq_autor_mat	= nr_seq_autorizacao_p;
/*PLS_GUIA_PLANO_PROC*/

delete	from	pls_guia_plano_proc
	where	nr_seq_guia		= nr_seq_autorizacao_p;
/*PLS_GUIA_PLANO_MAT*/

delete	from	pls_guia_plano_mat
	where	nr_seq_guia		= nr_seq_autorizacao_p;
/*PLS_DIAGNOSTICO*/

delete	from	pls_diagnostico
	where	nr_seq_guia		= nr_seq_autorizacao_p;
/*PLS_GUIA_PLANO_ANEXO*/

delete	from	pls_guia_plano_anexo
	where	nr_seq_guia		= nr_seq_autorizacao_p;
/*PLS_GUIA_PLANO_HISTORICO*/

delete	from	pls_guia_plano_historico
	where	nr_seq_guia		= nr_seq_autorizacao_p;
/*PLS_GUIA_CONTA*/

delete	from	pls_guia_conta
	where	nr_seq_guia		= nr_seq_autorizacao_p;

delete	from	pls_guia_conta
	where	nr_seq_guia_mat		= nr_seq_autorizacao_p;

delete	from	pls_guia_conta
	where	nr_seq_guia_proc	= nr_seq_autorizacao_p;
/*PLS_GUIA_,MOTIVO_LIB*/

delete	from	pls_guia_motivo_lib
	where	nr_seq_guia		= nr_seq_autorizacao_p;

delete	from	pls_guia_motivo_lib
	where	nr_seq_guia_mat		= nr_seq_autorizacao_p;

delete	from	pls_guia_motivo_lib
	where	nr_seq_guia_proc	= nr_seq_autorizacao_p;
/*PLS_GUIA_COPARTICIPACAO*/

delete	from	pls_guia_coparticipacao
	where	nr_seq_guia		= nr_seq_autorizacao_p;

delete	FROM PLS_GUIA_LIMINAR_JUDICIAL
where	nr_seq_guia		= nr_seq_autorizacao_p;

delete	FROM PLS_PRESTADOR_NEGATIVA
where	nr_seq_guia		= nr_seq_autorizacao_p;

delete	from	pls_guia_coparticipacao
	where	nr_seq_guia_proc	= nr_seq_autorizacao_p;
/*PLS_GUIA_PLANO*/

delete	from	pls_guia_plano
	where	nr_seq_guia_principal	= nr_seq_autorizacao_p;

delete	from	pls_guia_plano
	where	nr_sequencia		= nr_seq_autorizacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_limpar_base_autorizacao ( nr_seq_autorizacao_p bigint) FROM PUBLIC;

