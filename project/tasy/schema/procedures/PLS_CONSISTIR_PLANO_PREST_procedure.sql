-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_plano_prest ( nr_seq_plano_p bigint, nr_seq_conta_p bigint, nr_seq_guia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
ie_tipo_consistencia_w		varchar(1);
nr_seq_plano_w			bigint;
nr_seq_conta_w			bigint;
nr_seq_guia_w			bigint;
nr_seq_prestador_w		bigint;
nr_seq_plano_guia_conta_w	bigint;
ie_regulamentacao_w		varchar(1);
ie_lanca_glosa_w		varchar(2);
qt_inconsistencia_w		bigint;
nr_seq_prestador_guia_conta_w	bigint;

 
C01 CURSOR FOR 
	SELECT	nr_seq_prestador 
	from	pls_plano_prestador	a, 
		pls_plano		b 
	where	a.nr_seq_plano		= nr_seq_plano_p 
	and	a.nr_seq_plano		= b.nr_sequencia 
	and	a.ie_situacao		= 'A' 
	and	b.ie_rede_exclusiva 	= 'S' 
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
			

BEGIN 
if (coalesce(nr_seq_guia_p,0) > 0) then 
	ie_tipo_consistencia_w	:= 'G';
elsif (coalesce(nr_seq_conta_p,0) > 0) then 
	ie_tipo_consistencia_w	:= 'C';
end if;
 
if (ie_tipo_consistencia_w in ('G','C')) then 
	if (ie_tipo_consistencia_w = 'C') then	 
		begin 
		select	nr_seq_plano, 
			nr_seq_prestador_exec 
		into STRICT	nr_seq_plano_w, 
			nr_seq_prestador_guia_conta_w 
		from	pls_conta 
		where	nr_sequencia	= nr_seq_conta_p;
		exception 
		when others then 
			nr_seq_plano_w			:= null;
			nr_seq_prestador_guia_conta_w	:= null;
		end;
	elsif (ie_tipo_consistencia_w = 'G') then	 
		begin 
		select	nr_seq_plano, 
			nr_seq_prestador 
		into STRICT	nr_seq_plano_w, 
			nr_seq_prestador_guia_conta_w 
		from	pls_guia_plano 
		where	nr_sequencia	= nr_seq_guia_p;
		exception 
		when others then 
			nr_seq_plano_w	:= null;
			nr_seq_prestador_guia_conta_w 	:= null;
		end;
	end if;
end if;
open C01;
loop 
fetch C01 into 
	nr_seq_prestador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	if (nr_seq_plano_p = nr_seq_plano_w) then 
		if ((nr_seq_prestador_w = nr_seq_prestador_guia_conta_w) or (ie_lanca_glosa_w <> 'S')) then 
			ie_lanca_glosa_w := 'N';
		else	 
			ie_lanca_glosa_w := 'S';
		end if;
	else 
		ie_lanca_glosa_w := 'N';
	end if;	
end loop;
close C01;
 
if ( ie_lanca_glosa_w = 'S') then 
	if (ie_tipo_consistencia_w = 'G') then 
		CALL pls_gravar_motivo_glosa('2514',nr_seq_guia_p,null,null,'O produto não está cadastrado com o prestador informado.Favor verificar!',	 
		nm_usuario_p,'P','CG',nr_seq_prestador_w,'',null);
	elsif (ie_tipo_consistencia_w = 'C') then 
		CALL pls_gravar_conta_glosa('2514',nr_seq_conta_p, null,null,'N','O produto não está cadastrado com o prestado.Favor verificar!', 
		nm_usuario_p, 'A','CC',nr_seq_prestador_w, cd_estabelecimento_p, '', null);
	end if;
end if;	
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_plano_prest ( nr_seq_plano_p bigint, nr_seq_conta_p bigint, nr_seq_guia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
