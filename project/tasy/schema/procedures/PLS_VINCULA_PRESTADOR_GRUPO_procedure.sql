-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincula_prestador_grupo ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_grupo_p pls_preco_grupo_prestador.nr_sequencia%type, nr_seq_classificacao_p pls_classif_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/*
    Insere na tabela pls_preco_grupo_prestador, no id passado por parametro, todos os prestadores que
    tenham o mesmo codigo passado por parametro
*/
cd_prestador_w  pls_prestador.cd_prestador%type;

c01 CURSOR(cd_prestador_pc pls_prestador.cd_prestador%type) FOR
    SELECT nr_sequencia
    from   pls_prestador p_pres
    where  cd_prestador = cd_prestador_pc
	and	   not exists (SELECT   1
                       from     pls_preco_prestador p_prec
                       where    p_prec.nr_seq_prestador = p_pres.nr_sequencia
                       and      p_prec.nr_seq_grupo = nr_seq_grupo_p);

BEGIN

select  max(cd_prestador)
into STRICT    cd_prestador_w
from    pls_prestador a
where   a.nr_sequencia  = nr_seq_prestador_p;


for r_c01_w in c01(cd_prestador_w) loop
	begin
        insert into pls_preco_prestador(
                nr_sequencia,
                nr_seq_prestador,
                nr_seq_grupo,
                nr_seq_classificacao,
                nm_usuario_nrec,
                nm_usuario,
                dt_atualizacao_nrec,
                dt_atualizacao
            ) values (
                nextval('pls_preco_prestador_seq'),
                r_c01_w.nr_sequencia,
                nr_seq_grupo_p,
                nr_seq_classificacao_p,
                nm_usuario_p,
                nm_usuario_p,
                clock_timestamp(),
                clock_timestamp()
            );
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincula_prestador_grupo ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_grupo_p pls_preco_grupo_prestador.nr_sequencia%type, nr_seq_classificacao_p pls_classif_prestador.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
