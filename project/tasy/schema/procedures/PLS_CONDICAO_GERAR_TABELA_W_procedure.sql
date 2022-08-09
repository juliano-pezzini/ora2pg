-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_condicao_gerar_tabela_w ( nr_sequencia_p bigint, nr_seq_intercambio_p bigint, nr_seq_inter_plano_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_tipo_contratacao_w		varchar(2);
qt_registro_intercambio_w	bigint;
			

BEGIN 
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_intercambio_p IS NOT NULL AND nr_seq_intercambio_p::text <> '') and (nr_seq_inter_plano_p IS NOT NULL AND nr_seq_inter_plano_p::text <> '') and (nr_seq_plano_p IS NOT NULL AND nr_seq_plano_p::text <> '') and (nr_seq_tabela_p IS NOT NULL AND nr_seq_tabela_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	begin 
	 
	select	ie_tipo_contratacao 
	into STRICT	ie_tipo_contratacao_w 
	from	pls_plano 
	where	nr_sequencia = nr_sequencia_p;
	 
	if (ie_tipo_contratacao_w = 'CA' or ie_tipo_contratacao_w = 'CE') then 
		begin 
		 
		select	count(*) 
		into STRICT	qt_registro_intercambio_w	 
		from	pls_intercambio_plano 
        where	nr_seq_intercambio = nr_seq_intercambio_p;
		 
		if (qt_registro_intercambio_w > 0) then 
			begin 
			CALL pls_gerar_tabela_intercambio( 
						nr_seq_inter_plano_p, 
						nr_seq_plano_p, 
						nr_seq_tabela_p, 
						cd_estabelecimento_p, 
						nm_usuario_p, 
						'N');
			end;
		end if;
		 
		end;
	end if;
	 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_condicao_gerar_tabela_w ( nr_sequencia_p bigint, nr_seq_intercambio_p bigint, nr_seq_inter_plano_p bigint, nr_seq_plano_p bigint, nr_seq_tabela_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
