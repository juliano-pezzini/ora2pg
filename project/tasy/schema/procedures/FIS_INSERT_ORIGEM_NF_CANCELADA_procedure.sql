-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_insert_origem_nf_cancelada ( seq_nf_atual_p fis_origem_nf_cancel.seq_nf_atual%type, seq_nf_cancelada_p fis_origem_nf_cancel.seq_nf_cancelada%type, cd_estabelecimento_p fis_origem_nf_cancel.cd_estabelecimento%type, nm_usuario_p fis_origem_nf_cancel.nm_usuario%type, ie_commit_p text, nr_atendimento_p fis_origem_nf_cancel.nr_atendimento%type, nr_interno_conta_p fis_origem_nf_cancel.nr_interno_conta%type) AS $body$
BEGIN

	insert into fis_origem_nf_cancel(nr_sequencia,seq_nf_atual,seq_nf_cancelada,cd_estabelecimento, dt_atualizacao,dt_atualizacao_nrec,nm_usuario,nm_usuario_nrec,nr_atendimento,nr_interno_conta)
	values (nextval('fis_origem_nf_cancel_seq'),seq_nf_atual_p,seq_nf_cancelada_p,cd_estabelecimento_p,clock_timestamp(),clock_timestamp(),nm_usuario_p,nm_usuario_p,nr_atendimento_p,nr_interno_conta_p);

	if (coalesce(ie_commit_p,'S') = 'S') then
		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_insert_origem_nf_cancelada ( seq_nf_atual_p fis_origem_nf_cancel.seq_nf_atual%type, seq_nf_cancelada_p fis_origem_nf_cancel.seq_nf_cancelada%type, cd_estabelecimento_p fis_origem_nf_cancel.cd_estabelecimento%type, nm_usuario_p fis_origem_nf_cancel.nm_usuario%type, ie_commit_p text, nr_atendimento_p fis_origem_nf_cancel.nr_atendimento%type, nr_interno_conta_p fis_origem_nf_cancel.nr_interno_conta%type) FROM PUBLIC;

