-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_registrar_alt_transf (cd_pessoa_fisica_p text, ds_observacao_p text, nm_usuario_p text, nr_seq_unid_origem_p bigint, nr_seq_unid_destino_p bigint) AS $body$
BEGIN

insert into hd_pac_obs_transf(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,             
				dt_atualizacao_nrec,
				nm_usuario_nrec,        
				ds_observacao,          
				cd_pessoa_fisica,
				nr_seq_unid_origem,
				nr_seq_unid_destino
				)
			values (nextval('hd_pac_obs_transf_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				substr(ds_observacao_p,1,255),
				cd_pessoa_fisica_p,
				nr_seq_unid_origem_p,
				nr_seq_unid_destino_p
				);

    UPDATE hd_pac_renal_cronico
       SET nr_seq_unidade_atual = nr_seq_unid_destino_p,
           dt_atualizacao_nrec  = clock_timestamp(),
           nm_usuario_nrec      = nm_usuario_p
     WHERE cd_pessoa_fisica = cd_pessoa_fisica_p;
				
				
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_registrar_alt_transf (cd_pessoa_fisica_p text, ds_observacao_p text, nm_usuario_p text, nr_seq_unid_origem_p bigint, nr_seq_unid_destino_p bigint) FROM PUBLIC;

