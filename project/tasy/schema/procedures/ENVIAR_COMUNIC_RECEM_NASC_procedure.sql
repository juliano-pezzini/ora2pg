-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_comunic_recem_nasc ( nr_atendimento_p bigint, ds_perfil_adicional_p text, nm_usuario_p text) AS $body$
DECLARE

					 
nm_cirurgiao_princ_w	varchar(150);
nm_pediatra_w		varchar(150);
ds_pediatras_w		varchar(2000);
nm_mae_w		varchar(255);
ds_leito_w		varchar(50);
qt_peso_w		smallint;
qt_altura_w		real;
dt_nascimento_w		varchar(80);		
 
C01 CURSOR FOR 
	SELECT	obter_nome_pf(a.cd_pessoa_fisica) 
	from	cirurgia_participante a, 
		cirurgia b 
	where	ie_funcao = 	(SELECT max(x.cd_funcao) 
				from	funcao_medico x 
				where 	ie_pediatra = 'S' 
				and	upper(ds_funcao) like 'PEDIATRA') 
	and	b.nr_Atendimento = nr_atendimento_p 
	and	a.nr_cirurgia = b.nr_cirurgia 
	and	b.nr_cirurgia = (select max(y.nr_cirurgia) 
				from 	cirurgia y 
				where	y.nr_atendimento = nr_atendimento_p) 
	order by 1;	
 

BEGIN 
 
select 	max(substr(obter_nome_pf(a.cd_pessoa_fisica),1,150)) 
into STRICT	nm_cirurgiao_princ_w 
from 	cirurgia_participante a, 
	cirurgia b 
where	ie_funcao = 	(SELECT max(x.cd_funcao) 
			from	funcao_medico x 
			where 	ie_cirurgiao = 'S') 
and	b.nr_Atendimento = nr_atendimento_p 
and	a.nr_cirurgia = b.nr_cirurgia 
and	b.nr_cirurgia = (select max(y.nr_cirurgia) 
			from 	cirurgia y 
			where	y.nr_atendimento = nr_atendimento_p);
 
open C01;
loop 
fetch C01 into	 
	nm_pediatra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (coalesce(nm_pediatra_w,' ') <> ' ') then 
	  if (coalesce(ds_pediatras_w::text, '') = '') then 
		ds_pediatras_w := nm_pediatra_w;
	  else  
	    ds_pediatras_w := ds_pediatras_w ||', '||nm_pediatra_w;
	  end if;
	end if;
	end;
end loop;
close C01;
 
nm_mae_w 	:= Obter_Dados_Atendimento(nr_atendimento_p,'NP');
 
select max(cd_unidade_basica || '-' || cd_unidade_compl) 
into STRICT	ds_leito_w 
from  setor_atendimento b, 
    	atend_paciente_unidade a 
where  a.cd_setor_atendimento = b.cd_setor_atendimento 
and   a.nr_atendimento = nr_atendimento_p 
and   coalesce(a.dt_saida_unidade::text, '') = '';
 
select 	max(qt_peso), 
	max(qt_altura), 
	max(to_char(dt_nascimento,'dd/mm/yyyy hh24:mi:ss')) 
into STRICT	qt_peso_w, 
	qt_altura_w, 
	dt_nascimento_w 
from	nascimento 
where	nr_Atendimento = nr_atendimento_p;
 
 
insert	into comunic_interna( 
	dt_comunicado, 
	ds_titulo, 
	ds_comunicado, 
	nm_usuario, 
	dt_atualizacao, 
	ie_geral, 
	nm_usuario_destino, 
	nr_sequencia, 
	ie_gerencial, 
	nr_seq_classif, 
	ds_perfil_adicional, 
	cd_setor_destino, 
	cd_estab_destino, 
	ds_setor_adicional, 
	dt_liberacao) 
values (clock_timestamp(), 
	'Comunicação de Recém Nascido', 
	obter_desc_expressao(759466) || ' ' || nm_mae_w		|| chr(13) || chr(10) || -- Nome da Mãe 
	'Data e horas de nascimento:'	|| dt_nascimento_w	|| chr(13) || chr(10) || 
	obter_desc_expressao(295698) || qt_peso_w || obter_desc_expressao(304499)	 || chr(13) || chr(10) || -- Peso (qt_peso_w) Gramas 
	obter_desc_expressao(283402) || qt_altura_w || obter_desc_expressao(688843)	 || chr(13) || chr(10) || -- Altura (qt_altura_w) Centímetros 
	'Número do Quarto:'		||ds_leito_w		|| chr(13) || chr(10) || 
	'Pediatra(s):'			||ds_pediatras_w 	|| chr(13) || chr(10) || 
	obter_desc_expressao(294685) || ' ' || nm_cirurgiao_princ_w	, -- Obstetra 
	nm_usuario_p, 
	clock_timestamp(), 
	'N', 
	null, 
	nextval('comunic_interna_seq'), 
	'N', 
	null, 
	ds_perfil_adicional_p, 
	null, 
	null, 
	null, 
	clock_timestamp());
 
commit;
 
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_comunic_recem_nasc ( nr_atendimento_p bigint, ds_perfil_adicional_p text, nm_usuario_p text) FROM PUBLIC;

