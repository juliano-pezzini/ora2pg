-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_classif_acolh_pc ( nr_atendimento_p bigint, nr_seq_escuta_p bigint, nr_seq_classif_p bigint, nr_seq_triagem_prioridade_p bigint default null) AS $body$
DECLARE

									 
qt_reg_w			bigint;
cd_pessoa_fisica_w 	varchar(10);
nm_usuario_w		varchar(15);


BEGIN 
 
 
if ( nr_seq_escuta_p > 0) then 
 
	Select count(1) 
	into STRICT	qt_reg_w 
	from	ESCUTA_INICIAL_CLASSIF 
	where	nr_seq_escuta = nr_seq_escuta_p;
 
	Select obter_pessoa_Atendimento(nr_atendimento_p,'C') 
	into STRICT	cd_pessoa_fisica_w 
	;
 
	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
 
 
	if (qt_reg_w = 0) then 
 
		insert into escuta_inicial_classif( 	nr_sequencia, 
												dt_atualizacao, 
												nm_usuario, 
												dt_atualizacao_nrec, 
												nm_usuario_nrec, 
												nr_Atendimento, 
												ie_situacao, 
												cd_pessoa_fisica, 
												nr_seq_escuta, 
												NR_SEQ_CLASSIF, 
												NR_SEQ_TRIAGEM_PRIORIDADE) 
		 
									values ( 	nextval('escuta_inicial_classif_seq'), 
												clock_timestamp(), 
												nm_usuario_w, 
												clock_timestamp(), 
												nm_usuario_w, 
												nr_atendimento_p, 
												'A', 
												cd_pessoa_fisica_w, 
												nr_seq_escuta_p, 
												nr_seq_classif_p, 
												nr_seq_triagem_prioridade_p);
 
	elsif ( nr_atendimento_p > 0) then 
 
			update	escuta_inicial_classif 
			set 	NR_SEQ_CLASSIF 				= nr_seq_classif_p, 
					nr_seq_triagem_prioridade 	= nr_seq_triagem_prioridade_p 
			where	nr_atendimento				= nr_atendimento_p 
			and		nr_seq_escuta				= nr_seq_escuta_p;
			 
	end if;
 
	commit;
 
end if;	
	 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_classif_acolh_pc ( nr_atendimento_p bigint, nr_seq_escuta_p bigint, nr_seq_classif_p bigint, nr_seq_triagem_prioridade_p bigint default null) FROM PUBLIC;
