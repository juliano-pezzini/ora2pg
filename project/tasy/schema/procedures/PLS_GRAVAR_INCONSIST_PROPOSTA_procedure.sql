-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_inconsist_proposta ( nr_seq_proposta_p pls_proposta_adesao.nr_sequencia%type, nr_seq_benef_prop_p pls_proposta_beneficiario.nr_sequencia%type, cd_inconsistencia_p pls_inconsistencia_inc_seg.cd_inconsistencia%type, nr_seq_sca_vinculo_p bigint, nm_usuario_p text ) AS $body$
DECLARE


qt_inconsist_ativa_w		integer;
qt_registro_w			integer;
nr_seq_inconsistencia_w		pls_inconsistencia_inc_seg.nr_sequencia%type;


BEGIN

if (cd_inconsistencia_p IS NOT NULL AND cd_inconsistencia_p::text <> '') then
	select	count(1)
	into STRICT	qt_inconsist_ativa_w
	from	pls_inconsistencia_inc_seg
	where	ie_utilizacao in ('A','T')
	and	ie_situacao = 'A'
	and	cd_inconsistencia = cd_inconsistencia_p;
	
	if (qt_inconsist_ativa_w > 0) then
		select	nr_sequencia
		into STRICT	nr_seq_inconsistencia_w
		from	pls_inconsistencia_inc_seg
		where	cd_inconsistencia = cd_inconsistencia_p;
		
		select	count(1)
		into STRICT	qt_registro_w
		from	pls_proposta_validacao
		where	nr_seq_proposta	= nr_seq_proposta_p
		and	nr_seq_inconsist_fixa	= nr_seq_inconsistencia_w
		and (coalesce(nr_seq_sca_vinculo::text, '') = '' or nr_seq_sca_vinculo = nr_seq_sca_vinculo_p);
		
		if (qt_registro_w = 0) then
			insert into pls_proposta_validacao(	nr_sequencia, nr_seq_proposta, nr_seq_inconsist_fixa,
						ie_consistido, dt_atualizacao, nm_usuario,
						dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_segurado,nr_seq_sca_vinculo)
				values (	nextval('pls_proposta_validacao_seq'), nr_seq_proposta_p, nr_seq_inconsistencia_w,
						'I', clock_timestamp(), nm_usuario_p,
						clock_timestamp(), nm_usuario_p, nr_seq_benef_prop_p, nr_seq_sca_vinculo_p);
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_inconsist_proposta ( nr_seq_proposta_p pls_proposta_adesao.nr_sequencia%type, nr_seq_benef_prop_p pls_proposta_beneficiario.nr_sequencia%type, cd_inconsistencia_p pls_inconsistencia_inc_seg.cd_inconsistencia%type, nr_seq_sca_vinculo_p bigint, nm_usuario_p text ) FROM PUBLIC;
