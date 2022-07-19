-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_conta_complemento ( nr_seq_guia_p bigint, nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_conta_p INOUT bigint) AS $body$
DECLARE

 
				 
qt_guia_w			varchar(20);
nr_seq_conta_w			bigint;
nr_seq_prestador_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_regra_compl_w		bigint;
ie_tipo_complemento_w		varchar(1);


BEGIN 
 
select	count(nr_sequencia) 
into STRICT	qt_guia_w 
from	pls_conta 
where	nr_seq_protocolo = nr_seq_protocolo_p 
and	ie_estagio_complemento <> '2' 
and	cd_guia 	 = ( SELECT	cd_guia	 
			   from	pls_guia_plano 
			   where	nr_sequencia	= nr_seq_guia_p);
 
if (qt_guia_w = 0) then 
	select	count(nr_sequencia) 
    into STRICT	qt_guia_w 
    from	pls_conta 
    where	nr_seq_protocolo = nr_seq_protocolo_p 
    and	ie_estagio_complemento <> '2' 
    and	cd_guia_pesquisa = ( SELECT	cd_guia_pesquisa	 
	  			   from	pls_guia_plano 
				   where	nr_sequencia	= nr_seq_guia_p);
end if;
if (qt_guia_w = 0) then 
	nr_seq_conta_w := pls_gerar_guia_conta(	nr_seq_protocolo_p, nr_seq_guia_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_conta_w);	
	nr_seq_conta_p 	:=	nr_seq_conta_w;
else 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_conta_w 
	from	pls_conta 
	where	nr_seq_protocolo = nr_seq_protocolo_p 
	and	ie_estagio_complemento <> '2' 
	and	cd_guia = ( 	SELECT	cd_guia	 
				from	pls_guia_plano 
				where	nr_sequencia	= nr_seq_guia_p);
	nr_seq_conta_p 	:=	nr_seq_conta_w;
end if;
 
 
select	nr_seq_prestador, 
	nr_seq_segurado 
into STRICT	nr_seq_prestador_w, 
	nr_seq_segurado_w 
from	pls_conta 
where	nr_sequencia = nr_seq_conta_p;
 
 
select	max(nr_seq_regra_compl) 
into STRICT	nr_seq_regra_compl_w 
from	pls_guia_plano 
where	nr_sequencia = nr_seq_guia_p;
 
if (nr_seq_regra_compl_w IS NOT NULL AND nr_seq_regra_compl_w::text <> '' AND nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then 
	 
	select 	max(ie_tipo_complemento) 
	into STRICT	ie_tipo_complemento_w 
	from	pls_regra_conta_compl 
	where	nr_sequencia = nr_seq_regra_compl_w;
 
	if (ie_tipo_complemento_w IS NOT NULL AND ie_tipo_complemento_w::text <> '') then 
		update	pls_conta 
		set	ie_estagio_complemento 	= CASE WHEN ie_tipo_complemento_w=1 THEN 1  ELSE 4 END , 
			ie_origem_conta	    	= 'C', 
			nr_seq_regra_compl	= nr_seq_regra_compl_w 
		where 	nr_sequencia = nr_seq_conta_p;
	end if;
end if;
 
/* Eder 28-10-2010 procedure utilizado para informar o tipo de complemento que será utilizado na conta */
 
--pls_consiste_conta_complemento(nr_seq_conta_p, nr_seq_prestador_w, nr_seq_segurado_w, cd_estabelecimento_p, nm_usuario_p); 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_conta_complemento ( nr_seq_guia_p bigint, nr_seq_protocolo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_conta_p INOUT bigint) FROM PUBLIC;

