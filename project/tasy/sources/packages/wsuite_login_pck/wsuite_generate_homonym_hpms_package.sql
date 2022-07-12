-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wsuite_login_pck.wsuite_generate_homonym_hpms ( nm_pessoa_fisica_p pessoa_fisica.nm_pessoa_fisica%type, dt_nascimento_p pessoa_fisica.dt_nascimento%type, nr_cpf_p pessoa_fisica.nr_cpf%type, nr_seq_inclusao_benef_p wsuite_solic_inclusao_pf.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finality: Used by provider accreditation application.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */



BEGIN
	
CALL CALL wsuite_login_pck.wsuite_generate_homonym(nm_pessoa_fisica_p,
			dt_nascimento_p,
			nr_cpf_p,
			null,
			null,
			null,
			nr_seq_inclusao_benef_p,
			nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wsuite_login_pck.wsuite_generate_homonym_hpms ( nm_pessoa_fisica_p pessoa_fisica.nm_pessoa_fisica%type, dt_nascimento_p pessoa_fisica.dt_nascimento%type, nr_cpf_p pessoa_fisica.nr_cpf%type, nr_seq_inclusao_benef_p wsuite_solic_inclusao_pf.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;