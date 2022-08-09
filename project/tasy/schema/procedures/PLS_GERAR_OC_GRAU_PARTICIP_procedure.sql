-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_oc_grau_particip ( nr_seq_conta_p bigint, nr_seq_item_p bigint, nr_seq_grau_partic_p bigint, nr_seq_segurado_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_regra_p bigint, nm_usuario_p text, ds_observacao_p text, nr_seq_motivo_glosa_p bigint, ie_tipo_item_p bigint, cd_estabelecimento_p bigint, ie_reconsistencia_p text, ie_gerou_ocorrencia_p INOUT text ) AS $body$
DECLARE

 
/* 
ESTA REGRA VAI GERAR OCORRÊNCIA PARA CADA PARTICIPANTE QUE SE ENCAIXAR N=O GRAU DE PARTICIPAÇÃO. 
*/
				 
	 
				 
ie_existe_w		varchar(2);				
	 
nr_seq_partic_w			bigint:= null;
nr_Seq_conta_w			bigint;
cd_medico_conta_w		numeric(20);
cd_medico_partic_w		numeric(20);
nr_Seq_prestador_partic_w	bigint;

nm_particpante_w		varchar(255);		
ie_tipo_w			varchar(1);	
ds_observacao_w			varchar(4000);
ie_gerou_ocorrencia_w		varchar(1);

nr_seq_ocorrencia_benef_w	bigint; --ocorrencia gerada 
 
C01 CURSOR FOR /*ESTE CURSOR VERIFICA A PARTICIPACAO DO MEDICO PELO ITEM*/
	 
	SELECT	'1', --conta 
		null, 
		b.cd_medico_executor, 
		null nr_Seq_prestador				 
	from	pls_conta_proc 	a, 
		pls_conta 	b		 
	where	a.nr_seq_conta 		= b.nr_sequencia	 
	and	b.nr_seq_grau_partic	= nr_seq_grau_partic_p 
	and	a.nr_sequencia		= nr_seq_item_p 
	
union
  --participante 
	SELECT	'2', 
		c.nr_sequencia, 
		c.cd_medico, 
		c.nr_Seq_prestador				 
	from	pls_conta_proc a, 
		pls_conta b, 
		pls_proc_participante c 
	where	a.nr_seq_conta 		= b.nr_sequencia 
	and	a.nr_sequencia		= c.nr_seq_conta_proc 
	and	c.nr_seq_grau_partic	= nr_seq_grau_partic_p 
	and	a.nr_sequencia		= nr_seq_item_p;
	
	 
	 
C02 CURSOR FOR /*ESTE CURSOR VERIFICA A PARTICIPACAO DO MEDICO PELA CONTA*/
 
	SELECT '1', --conta 
		null, 
		b.cd_medico_executor, 
		null nr_Seq_prestador		 
	from	pls_conta_proc 	a, 
		pls_conta 	b		 
	where	a.nr_seq_conta 		= b.nr_sequencia 
	and	b.nr_seq_grau_partic	= nr_seq_grau_partic_p 
	and	a.nr_seq_conta		= nr_seq_conta_p 
	
union
 
	SELECT '2', --participante 
		c.nr_sequencia, 
		c.cd_medico, 
		c.nr_Seq_prestador	 
	from	pls_conta_proc a, 
		pls_conta b, 
		pls_proc_participante c 
	where	a.nr_seq_conta 		= b.nr_sequencia 
	and	a.nr_sequencia		= c.nr_seq_conta_proc 
	and	c.nr_seq_grau_partic	= nr_seq_grau_partic_p 
	and	a.nr_seq_conta		= nr_seq_conta_p;
				

BEGIN 
 
ie_gerou_ocorrencia_w 	:= 'N';
 
 
/*nao checa, caso seja uma reconsistencia da análise*/
 
if ( ie_reconsistencia_p = 'S') then	 
	goto final;
end if;
	 
if ( coalesce(nr_seq_item_p,0) > 0) then 
	 
	open C01;
	loop 
	fetch C01 into	 
		ie_tipo_w, 
		nr_seq_partic_w, 
		cd_medico_partic_w, 
		nr_Seq_prestador_partic_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ie_gerou_ocorrencia_w	:= 'S';	
	 
	nr_seq_ocorrencia_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, null, nr_seq_conta_p, nr_seq_item_p, null, nr_seq_regra_p, nm_usuario_p, ds_observacao_p, nr_seq_motivo_glosa_p, ie_tipo_item_p, cd_estabelecimento_p, 'N', null, nr_seq_ocorrencia_benef_w, null, nr_seq_partic_w, null, null);		
	 
	end;
	end loop;
	close C01;	
	 
elsif (coalesce(nr_seq_conta_p,0) > 0) then 
	 
	open C02;
	loop 
	fetch C02 into	 
		ie_tipo_w, 
		nr_seq_partic_w, 
		cd_medico_partic_w, 
		nr_Seq_prestador_partic_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		ie_gerou_ocorrencia_w	:= 'S';			
		 
		nr_seq_ocorrencia_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_p, nr_seq_ocorrencia_p, null, null, nr_seq_conta_p, nr_seq_item_p, null, nr_seq_regra_p, nm_usuario_p, ds_observacao_p, nr_seq_motivo_glosa_p, ie_tipo_item_p, cd_estabelecimento_p, 'N', null, nr_seq_ocorrencia_benef_w, null, nr_seq_partic_w, null, null);
		end;
	end loop;
	close C02;
	 
end if;
 
<<final>> 
ie_gerou_ocorrencia_p	:= ie_gerou_ocorrencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_oc_grau_particip ( nr_seq_conta_p bigint, nr_seq_item_p bigint, nr_seq_grau_partic_p bigint, nr_seq_segurado_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_regra_p bigint, nm_usuario_p text, ds_observacao_p text, nr_seq_motivo_glosa_p bigint, ie_tipo_item_p bigint, cd_estabelecimento_p bigint, ie_reconsistencia_p text, ie_gerou_ocorrencia_p INOUT text ) FROM PUBLIC;
