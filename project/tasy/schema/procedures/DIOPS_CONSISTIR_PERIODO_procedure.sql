-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diops_consistir_periodo ( nr_seq_periodo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
qt_registro_w			integer	:= 0;
ie_tipo_periodo_diops_w		varchar(10);


BEGIN 
 
select	coalesce(max(ie_tipo_periodo_diops),'T') 
into STRICT	ie_tipo_periodo_diops_w 
from	diops_periodo 
where	nr_sequencia	= nr_seq_periodo_p;
 
/* Felipe - 27/11/2010 - Estava sendo realizada as consistências para o Fluxo de Caixa mensal também, dessa forma apresentava erro*/
 
if (ie_tipo_periodo_diops_w	= 'T') then 
	delete 	from diops_periodo_inconsist 
	where	nr_seq_periodo	= nr_seq_periodo_p;
 
	CALL diops_consistir_dados_cadastro(nr_seq_periodo_p, nm_usuario_p, cd_estabelecimento_p);
	CALL diops_consistir_administrador(nr_seq_periodo_p, nm_usuario_p, cd_estabelecimento_p);
	CALL diops_consistir_responsavel(nr_seq_periodo_p, nm_usuario_p, cd_estabelecimento_p);
	CALL diops_consistir_representante(nr_seq_periodo_p, nm_usuario_p, cd_estabelecimento_p);
	CALL diops_consistir_represenRN117(nr_seq_periodo_p, nm_usuario_p, cd_estabelecimento_p);
	CALL diops_consistir_balancete(nr_seq_periodo_p, nm_usuario_p, cd_estabelecimento_p);
 
	CALL pls_diops_gravar_historico(nr_seq_periodo_p,3,'','',nm_usuario_p);
	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diops_consistir_periodo ( nr_seq_periodo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

